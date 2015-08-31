#!/bin/sh

PLATFORM=ngc

make -C ../ -f Makefile.griffin platform=${PLATFORM} clean || exit 1

for f in *_${PLATFORM}.a ; do
   name=`echo "$f" | sed "s/\(_libretro_${PLATFORM}\|\).a$//"`
   whole_archive=
   big_stack=
   if [ $name = "nxengine" ] ; then
      echo "NXEngine found, applying whole archive linking..."
      whole_archive="WHOLE_ARCHIVE_LINK=1"
   fi
   if [ $name = "tyrquake" ] ; then
      echo "Tyrquake found, applying big stack..."
      big_stack="BIG_STACK=1"
   fi
   cp -f "$f" ../libretro_${PLATFORM}.a
   make -C ../ -f Makefile.griffin platform=${PLATFORM} $whole_archive $big_stack -j3 || exit 1
   mv -f ../retroarch_${PLATFORM}.dol ../pkg/${PLATFORM}/${name}_libretro_${PLATFORM}.dol
   rm -f ../retroarch_${PLATFORM}.dol ../retroarch_${PLATFORM}.elf ../retroarch_${PLATFORM}.elf.map
done
