nv_uboot image for HP Chromebook 11 (daisy_spring)
===============

This is a github clone of the nv_boot-spring.kpart image I built from the Chromiumos source code.  It is suitable for non-verified booting of the HP Chromebook 11.  Basically, it can be used in the same way as nv_boot-snow.kpart from Google.  

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
