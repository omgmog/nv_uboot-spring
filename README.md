nv_uboot image for HP Chromebook 11 (daisy_spring)
===============

This is a github clone of the nv_boot-spring.kpart image I built from the Chromiumos source code.  It is suitable for non-verified booting of the HP Chromebook 11.  Basically, it can be used in the same way as nv_boot-snow.kpart from Google.  

Revision 2 added
--------------------------

I went ahead and rebuilt the nv_uboot image with the [USB Hub Delay Patch](https://chromium-review.googlesource.com/#/c/65542/).  That causes uboot to pause and wait for usb devices to enumerate when booting (fixes slow usb keys I believe).  I was hoping it would address some issues booting from the eMMC where uboot seems to come up too fast and you end up at the uboot prompt.  The jury is still out but if this happens to you, count to 5 and then type "run non_verified_boot" at the prompt and it should try to boot again.  


How'd I'd build this anyway?
---------------------------

I'm assuming if you want to build your own, you've read [Appendix A on Google](http://www.chromium.org/chromium-os/u-boot-porting-guide/using-nv-u-boot-on-the-samsung-arm-chromebook).  Essentially this was built the same way, with a few minor tweaks.  

As you set up your repository as laid out in the [Chromium OS Developer Guide](http://www.chromium.org/chromium-os/developer-guide), you'll want to initialize your repo to the *firmware-spring-3824.B* branch.  So when you get to that part,

```bash
repo init -u https://chromium.googlesource.com/chromiumos/manifest.git --repo-url https://chromium.googlesource.com/external/repo.git -b firmware-spring-3824.B
```

That will get you a repo able to build this firmware.  Carry on through the developer guide to at least the ./board-setup step.  Here you'll set the board to *daisy_spring*.  

Finally you'll want to use the [script the referenced on the Google Appendix A page](http://www.chromium.org/chromium-os/u-boot-porting-guide/using-nv-u-boot-on-the-samsung-arm-chromebook#TOC-Installing-nv-U-Boot-chained-U-Boot-method-) to build the kpart.  The nvboot.sh script in this repo is essentially that script, modified to build for daisy_spring.  It also git pulls from googlesource.com so you don't have to mess with gerrit.  It should build the kpart.  

If memory serves, the first time I ran through the build, it failed building one of the ec modules (the embedded controller for the keyboard).  I edited the ebuild for the file and forced EC_BOARD to be "spring" and it built successfully.  If you run into the same issue, it's worth a shot.  

Good luck!
