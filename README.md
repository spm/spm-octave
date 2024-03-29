# SPM Patches for Octave

More details on the [SPM documentation](https://www.fil.ion.ucl.ac.uk/spm/docs/installation/octave/).

A patched [SPM](https://www.fil.ion.ucl.ac.uk/spm/) can be installed on [Octave](https://octave.org/) using the following script:

```matlab
%% Store current working directory
cwd = pwd;

%% Download SPM12 r7771
unzip ("https://github.com/spm/spm12/archive/r7771.zip", cwd);

%% Patch SPM12
urlwrite ("https://raw.githubusercontent.com/spm/spm-octave/main/spm12_r7771.patch", "spm12_r7771.patch");
system ("patch -p3 -d spm12-r7771 < spm12_r7771.patch");

%% Compile MEX files
cd (fullfile (cwd, "spm12-r7771", "src"));
system ("make PLATFORM=octave");
system ("make PLATFORM=octave install");

%% Add SPM12 to the function search path
addpath (fullfile (cwd, "spm12-r7771"));
cd (cwd);

%% Start SPM12
spm
```

The patches contain implementations of:
* `fcnchk.m`: undocumented function
* `rng.m`: function introduced in [Octave 7.1](https://octave.org/NEWS-7.html)
* `gui_mainfcn.m`: undocumented function introduced in [Octave 6.1](https://octave.org/NEWS-6.1.html)