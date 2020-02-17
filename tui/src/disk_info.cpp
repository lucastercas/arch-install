/*
 *   hdm.c - Hard Disk Metadata
 *
 *   Copyright (C) Finnbarr P. Murphy 2010  <fpm[AT]fpmurphy.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License Version 2 as
 *   published by the Free Software Foundation.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 *
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <linux/fs.h>
#include <asm/byteorder.h>
#include <sys/ioctl.h>
#include <linux/hdreg.h>
#include <parted/parted.h>
 
#define DUMPXML          1
#define DUMPTXT          2
#define DUMPCSV          3
#define NONEWLINE        0
 
#define DI_VERSION       "1.0"
#define TRANSPORT_MAJOR   0xDE
#define TRANSPORT_MINOR   0xDF
#define ATA_PIDENTIFY     0xA1
#define ATA_IDENTIFY      0xEC
#define NMRR              0xD9
#define CAPAB             0x31
#define CMDS_SUPP_1       0x53 
#define VALID             0xC000
#define VALID_VAL         0x4000
#define SUPPORT_48_BIT    0x0400
#define LBA_SUP           0x0200
#define LBA_LSB           0x64
#define LBA_MID           0x65
#define LBA_48_MSB        0x66
#define LBA_64_MSB        0x67
 
/* yes - these are shortcuts! */
static __u16 *id = (void *)NULL;
static struct hd_geometry *g;
static int fd = 0;
 
struct hd_geometry *
get_geometry(int fd)
{
    static struct hd_geometry geometry;
 
    if (ioctl(fd, HDIO_GETGEO, &geometry)) {
        perror("ERROR: HDIO_GETGEO failed");
    }
 
    return &geometry;
}
 
 
void *get_diskinfo(int fd) {
    static __u8 args[4+512];
    __u16 *id = (void *)(args + 4);
    int i;
 
    memset(args, 0, sizeof(args));
    args[0] = ATA_IDENTIFY;
    args[3] = 1;
    if (ioctl(fd, HDIO_DRIVE_CMD, args)) {
        args[0] = ATA_PIDENTIFY;
        args[1] = 0;
        args[2] = 0;
        args[3] = 1;
        if (ioctl(fd, HDIO_DRIVE_CMD, args)) {
            perror("ERROR: HDIO_DRIVE_CMD failed");
            return "";
        }
    }
 
    /* byte-swap data to match host endianness */
    for (i = 0; i < 0x100; ++i)
         __le16_to_cpus(&id[i]);
 
    return id;
}
 
// Routine currently only handles SATA drives. 
// Extra code needs to be added to support PATA, SCSI, USB, etc.
char *
get_transport(__u16 id[])
{
    __u16 major, minor;
    unsigned int ttype, stype;
 
    major = id[TRANSPORT_MAJOR];
    minor = id[TRANSPORT_MINOR];
 
    if (major == 0x0000 || major == 0xffff)
        return "";
 
    ttype = major >> 12;      /* transport type */
    stype = major & 0xfff;    /* subtype */
 
    if (ttype == 1) {
         if (stype & 0x2f) {
             if (stype & (1<<5))
                 return "SATA Rev 3.0";
             else if (stype & (1<<4))
                 return "SATA Rev 2.6";
             else if (stype & (1<<3))
                 return "SATA Rev 2.5";
             else if (stype & (1<<2))
                 return "SATA II Extensions";
             else if (stype & (1<<1))
                 return "SATA 1.0a";
         }
    }
}
 
 
char *
get_rpm(__u16 id[])
{
   static char str[6];
   __u16 i = id[NMRR];
 
   sprintf(str,"%u", i);
 
   return str;
}
 
 
char *
ascii_string(__u16 *p,
             unsigned int len)
{
    __u8 i, c;
    char cl;
    static char str[60];
    char *s = str;
 
    memset(&str, 0, sizeof(str));
 
    /* find first character */
    for (i = 0; i < len; i++) {
        if (( (char)0x00ff & ((*p) >> 8)) != ' ')
            break;
        if ((cl = (char) 0x00ff & (*p)) != ' ') {
            if (cl != '\0') *s++ = cl;
            p++; i++;
            break;
        }
        p++;
    }
    /* copy from here to end */
    for (; i < len; i++) {
        c = (*p) >> 8;
        if (c) *s++ = c;
        c = (*p);
        if (c) *s++ = c;
        p++;
    }
 
    /* remove trailing blanks */
    s = str;
    while(*s) s++;
    while(*--s == ' ') *s= 0;
 
    return str;
}
 
 
#define USE_CAPAB
char *
get_capacity(int fd, __u16 id[])
{
    unsigned int sector_bytes = 512;
    static char str[20];
    __u64 sectors = 0;
 
#ifdef USE_CAPAB
    memset(&str, 0, sizeof(str));
 
    if (id[CAPAB] & LBA_SUP) {
        if (((id[CMDS_SUPP_1] & VALID) == VALID_VAL) && (id[CMDS_SUPP_1] & SUPPORT_48_BIT) ) {
            sectors = (__u64)id[LBA_64_MSB] << 48 | (__u64)id[LBA_48_MSB] << 32 |
                      (__u64)id[LBA_MID] << 16 | id[LBA_LSB] ;
        }
    }
#else
    unsigned int sector32 = 0;
 
    if (!(ioctl(fd, BLKGETSIZE64, &sectors))) {            // bytes
          sectors /= sector_bytes;
    } else if (!(ioctl(fd, BLKGETSIZE, &sector32))) {      // sectors
          sectors = sector32;
    } else
          return "";
#endif
 
    sectors *= (sector_bytes /512);
    sectors = (sectors << 9)/1000000;
    if (sectors > 1000)
        sprintf(str, "%lluGB", (unsigned long long) sectors/1000);
    else
        sprintf(str, "%lluMB", (unsigned long long) sectors);
 
    return str;
}
 
 
void
dump_partitions(char *device, int dumpmode, int nlmode)
{
    PedDevice *dev = (PedDevice *)NULL;
    PedDiskType* type;
    PedDisk* disk = (PedDisk *)NULL;
    PedPartition* part;
    PedPartitionFlag flag;
    PedUnit default_unit;
    int has_free_arg = 0;
 
    char *start;
    char *end;
    char *size;
    char flags[100];
    const char *partname;
    const char *parttype;
    const char *partlabel;
    const char *partflags;
    int first_flag;
 
    dev = ped_device_get(device);
    if (!ped_device_open (dev)) {
       fprintf(stderr, "ERROR: ped-device-opem\n");
       exit(1);
    }
 
    disk = ped_disk_new(dev);
    if (!disk) {
       fprintf(stderr, "ERROR: ped-disk-new\n");
       exit(1);
    }
 
    start = ped_unit_format(dev, 0);
    default_unit = ped_unit_get_default();
    end = ped_unit_format_byte (dev, dev->length * dev->sector_size
          - (default_unit == PED_UNIT_CHS || default_unit == PED_UNIT_CYLINDER));
 
    switch (dumpmode) {
       case DUMPXML:
          if (nlmode) printf("\n    ");
          printf("<partitiontype>%s<paritiontype>", disk->type->name);
          if (nlmode) printf("\n    ");
          printf("<partitions>");
          break;
       case DUMPTXT:
          printf("    Partition Type: %s\n", disk->type->name);
          printf("    No.  Start   End     Size      Type      Filesystem   Name  Flags\n");
          break;
       case DUMPCSV:
          putchar('"'); putchar(','); putchar('"');
          printf("%s", disk->type->name );
          break;
    }
 
    free(start);
    free(end);
 
    for (part = ped_disk_next_partition (disk, NULL); part;
        part = ped_disk_next_partition (disk, part)) {
 
         if ((!has_free_arg && !ped_partition_is_active(part)) ||
             part->type & PED_PARTITION_METADATA)
             continue;
 
         start = ped_unit_format (dev, part->geom.start);
         end = ped_unit_format_byte (dev, (part->geom.end + 1) * (dev)->sector_size - 1);
         size = ped_unit_format (dev, part->geom.length);
 
         if (!(part->type & PED_PARTITION_FREESPACE)) {
              parttype = ped_partition_type_get_name (part->type);
              partlabel = ped_partition_get_name(part);
         } else {
              parttype = "";
              partlabel = "";
         }
 
         // flags
         memset(&flags, 0, sizeof(flags));
         first_flag = 1;
         for (flag = ped_partition_flag_next(0); flag;
              flag = ped_partition_flag_next(flag)) {
              if (ped_partition_get_flag(part, flag)) {
                   if (first_flag) {
                        first_flag = 0;
                   } else {
                        strcat (flags, ", ");
                   }
                   partflags = ped_partition_flag_get_name(flag);
                   strcat(flags, partflags);
              }
         }
         switch (dumpmode) {
             case DUMPXML:
                 if (nlmode) printf("\n        ");
                 if (part->num >= 0)
                      printf("<partition number=\"%d\">", part->num);
                 else
                      printf("<partition number=\"0\">");
                 if (nlmode) printf("\n            ");
                 printf("<start>%s</start>", start);
                 if (nlmode) printf("\n            ");
                 printf("<end>%s</end>", end);
                 if (nlmode) printf("\n            ");
                 printf("<size>%s</size>", size);
                 if (nlmode) printf("\n            ");
                 printf("<type>%s</type>", parttype);
                 if (nlmode) printf("\n            ");
                 printf("<filesystem>%s</filesystem>", part->fs_type ? part->fs_type->name : "");
                 if (nlmode) printf("\n            ");
                 printf("<label>%s</label>", partlabel);
                 if (nlmode) printf("\n            ");
                 printf("<flags>%s</flags>", flags);
                 if (nlmode) printf("\n        ");
                 printf("</partition>");
                 break;
             case DUMPTXT:
                 if (part->num >= 0)
                      printf("    %02d", part->num);
                 else
                      printf("        ");
                 printf("  %6s  %6s  %6s  %10s", start, end, size, parttype);
                 printf("  %6s", part->fs_type ? part->fs_type->name : "");
                 printf("  %10s  %s\n", partlabel, flags);
                 break;
             case DUMPCSV:
                 putchar('"'); putchar(','); putchar('"');
                 if (part->num >= 0) printf("%02d", part->num);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", start);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", end);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", size);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", parttype);
                 putchar('"'); putchar(','); putchar('"');
                 if (part->fs_type) printf("%s", part->fs_type->name);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", partlabel);
                 putchar('"'); putchar(','); putchar('"');
                 printf("%s", flags);
                 break;
        }
 
        free(start);
        free(end);
        free(size);
    }
 
    switch (dumpmode) {
       case DUMPXML:
            if (nlmode) printf("\n    ");
            printf("</partitions>");
            break;
       case DUMPTXT:
            break;
       case DUMPCSV:
            putchar('"');
            break;
    }
}
 
 
void
dump(char *device)
{
    int len = strlen(device) + 8;
    int i = 0;
 
    printf("\nDEVICE: %s\n", device);
    while(i++ < len) putchar('-');
    putchar('\n');
    printf("Manufacturer Model: %s\n", ascii_string(&id[27],20));
    printf("     Serial Number: %s\n", ascii_string(&id[10],10));
    printf(" Firmware Revision: %s\n", ascii_string(&id[23],4));
    printf("    Transport Type: %s\n", get_transport(id));
    printf("       Maximum RPM: %s\n", get_rpm(id));
    printf("          Capacity: %s\n", get_capacity(fd, id));
    printf("  Number Cylinders: %u\n", g->cylinders);
 
    dump_partitions(device, DUMPTXT, NONEWLINE);
}
 
 
void
dumpxml(char *device, int nlmode)
{
    printf("<disk dev=\"%s\">", device);
    if (nlmode) printf("\n    ");
    printf("<model>%s</model>", ascii_string(&id[27],20));
    if (nlmode) printf("\n    ");
    printf("<serialno>%s</serialno>", ascii_string(&id[10],10));
    if (nlmode) printf("\n    ");
    printf("<firmware>%s</firmware>", ascii_string(&id[23],4));
    if (nlmode) printf("\n    ");
    printf("<transport>%s</transport>", get_transport(id));
    if (nlmode) printf("\n    ");
    printf("<rpm>%s</rpm>", get_rpm(id));
    if (nlmode) printf("\n    ");
    printf("<capacity>%s</capacity>", get_capacity(fd, id));
    if (nlmode) printf("\n    ");
    printf("<geometry>");
    if (nlmode) printf("\n        ");
    printf("<cylinders>%u</cylinders>", (unsigned short) g->cylinders);
    if (nlmode) printf("\n        ");
    printf("<heads>%u</heads>", (unsigned char) g->heads);
    if (nlmode) printf("\n        ");
    printf("<sectors>%u</sectors>", (unsigned char) g->sectors);
    if (nlmode) printf("\n    ");
    printf("</geometry>");
    dump_partitions(device, DUMPXML, nlmode);
    if (nlmode) putchar('\n');
    printf("</disk>");
    if (nlmode) putchar('\n');
}
 
 
void
dumpcsv(char *device)
{
    putchar('"');
    printf("%s", ascii_string(&id[27],20));
    putchar('"'); putchar(','); putchar('"');
    printf("%s", ascii_string(&id[10],10));
    putchar('"'); putchar(','); putchar('"');
    printf("%s", ascii_string(&id[23],4));
    putchar('"'); putchar(','); putchar('"');
    printf("%s", get_transport(id));
    putchar('"'); putchar(','); putchar('"');
    printf("%s", get_rpm(id));
    putchar('"'); putchar(','); putchar('"');
    printf("%s", get_capacity(fd, id));
    putchar('"'); putchar(','); putchar('"');
    printf("%u", g->cylinders);
    putchar('"'); putchar(','); putchar('"');
    printf("%u", g->heads);
    putchar('"'); putchar(','); putchar('"');
    printf("%u", g->sectors);
    putchar('"');
    dump_partitions(device, DUMPCSV, NONEWLINE);
}
 
 
void
usage()
{
    printf("usage: di [-n] [-c|-csv|-x|--xml] devicepath\n");
    printf("usage: di [-v |--version ]\n");
}
 
 
int
main(int argc,
     char *argv[])
{
    static struct hd_driveid hd;
    int option_index = 0, c;
    int xmlmode = 0, nlmode = 0, csvmode = 0;
    char *device;
 
    static struct option long_options[] = {
        {"csv", no_argument, 0, 'c'},
        {"help", no_argument, 0, 'h'},
        {"newline", no_argument, 0, 'n'},
        {"version", no_argument, 0, 'v'},
        {"xml", no_argument, 0, 'x'},
        {0, 0, 0, 0}
    };
 
    while ((c = getopt_long(argc, argv, "chnvx", long_options, &option_index)) != -1) {
        switch (c) {
            case 'h':
                usage();
                exit(EXIT_SUCCESS);
            case 'c':
                csvmode = 1;
                break;
            case 'n':
                nlmode = 1;
                break;
            case 'x':
                xmlmode = 1;
                break;
            case 'v':
                fprintf(stdout, "version %s\n", DI_VERSION);
                exit(EXIT_SUCCESS);
            default: /* '?' */
                usage();
                exit(EXIT_FAILURE);
        }
    }
 
    if (csvmode && xmlmode) {
        fprintf(stderr, "ERROR: Select either XML or CVS for formatted output\n");
        exit(EXIT_FAILURE);
    }
 
    if (optind >= argc) {
        fprintf(stderr, "ERROR: No devicepath provided\n");
        exit(EXIT_FAILURE);
    }
 
    if (geteuid() >  0) {
        fprintf(stderr, "ERROR: Must be root to use\n");
        exit(EXIT_FAILURE);
    }
 
    device = argv[optind];
    if ((fd = open(device, O_RDONLY|O_NONBLOCK)) < 0) {
        fprintf(stderr, "ERROR: Cannot open device %s\n", argv[1]);
        exit(EXIT_FAILURE);
    }
 
    id = get_diskinfo(fd);
    g  = get_geometry(fd);
 
    if (ioctl(fd, HDIO_GET_IDENTITY, &hd) < 0 ) {
        if (errno == -ENOMSG) {
            fprintf(stderr, "ERROR: No hard disk identification information available\n");
        } else {
            perror("ERROR: HDIO_GET_IDENTITY");
            exit(1);
        }
    }
 
    close(fd);
 
    if (csvmode)
        dumpcsv(device);
    else if (xmlmode)
        dumpxml(device, nlmode);
    else
        dump(device);
 
    exit(EXIT_SUCCESS);
}