# Perl scripts for Quantum Mechanical (QM) computational chemistry calculations using Gaussian 03 and ChemSol 

During my graduate work at Loyola University Chicago under the supervision of Dr. Jan Florian, I used the well-known Gaussian suite of QM computational chemistry programs along with ChemSol for the calculation of Langevin Dipoles solvation free energies. This project contains a set of utilities that I wrote for the submission and extraction of data during my dissertation project. These script can be used to produce Gnuplot output such as this:
![PES](http://i.imgur.com/Qkfxm.png)

## Job submission

The scripts for submitting data to the nodes use ssh to launch remote processes. They are meant to be used in a Unix environment and were developed in Mac OS X 10.5. The utilities are dependent upon two config files:

#### config/submits
**submit.pl** writes jobs to this file by default and **submitd.pl** reads from it. The location of this file can be changed by editing *$submitfile* in **submit.pl** and *$submitf* in **submitd.pl**.

#### config/cpumap.txt
File which contains a map of the nodes and their load limits. An example file is included. Each line is of the form:
```html
<Node Name>   <CORE Count>
```		    
Any line beginging with # is ignored as a comment. The location of this file can be changed by editing *$cpumap* in **submitd.pl**.
		
#### submit.pl 
Script for generating a list of jobs to be submitted to the nodes. Gaussian input files should have the ending ".com" ChemSol files should have the ending ".cs". The usage is as follows:
```bash
$ submit.pl Calc1.com Calc2.com Calc3.com
```
or equivalently
```bash
$ submit.pl Calc*.com
```

#### submitd.pl
Job submission daemon. Will read from config/submits by default. 
Usage: 
```bash
$ submitd.pl 
```
If you prefer to run it as a background process with stderr and stdout piped to submitd.log:
```bash
$ submitd.pl 1 >> submitd.log 2>&1 &
```

**submitd.pl** is dependent upon having the proper configuration on the nodes. The Gaussian 03 (**g03**) binary and ChemSol 2.1 (**cs21**) must live in a place that is in your **$PATH** on the node machine. The script relies on the fact that there is a shared network drive that is accessible by the nodes and any filenames in **config/submits**  are relative to their positions on the shared drive.

## Extraction of geometries from Gaussian geometry optimization output files (.log)

There are two utilities for extracting data from output files

### geom.pl 
Extracts optimized gas-phase geometries from gaussian output (.log) files and prepares input files for Gaussian calculations (.com) using the optimized geometries.

### geomld.pl 
Works similarly to geom.pl, except that it prepares ChemSol (.cs) input files. 

Use the command line option "-h" with **geom.pl** and **geomld.pl** for further details on their usage.

## Creation of surfaces

These scripts extract data from Gaussian and ChemSol output files (.log and .cs). The data is meant to be plotted using Gnuplot's **splot** function. The file **PES.plt** contains an example Gnuplot script for generating 3D potential energy surfaces.

#### get-surface.pl
Utility used to extract data from a surface calculation dir. It outputs surface.txt files

#### combine-surfaces.pl
Recombines surfaces extracted with get-surface.pl. If there are points with different energies for redundant coordinates contained in the surface .txt files, the point with the lowest total delta G (gas phase SCF + solvation free energy) will be used. 

Use the command line option "-h" with **get-surface.pl** and **combine-surfaces.pl** for further details on their usage.

## Future Work

**submitd.pl** could easily be generalized for executing programs on remote machines for which you only have access via ssh.

**get-surface.pl** and **combine-surfaces.pl** could also be generalized to use generic reaction coordinate parameters and not just bond lengths.

These scripts are rather specific for gas-phase optimizations along two reaction coordinates that are bondlengths. They do not utilize any CPAN modules and tend towards a more "functional" or "iterative" approach when it comes to data extraction. If others find these scripts useful and want to expand the features, I would be glad to help.

I would like it if these scripts worked for no-cost QM programs such as GAMESS or open source QM programs such as FreeON. I do not have experience with these programs, but I would like to work with someone who does. If you think that these scripts could help you in your work, I would be more than happy to help you make them compatible with a freely available QM package.

## License

This program is licensed under GPLv2. See LICENSE for more details.

## Contact 

Email: jmborden@gmail.com
GitHub: jborden on [GitHub](https://github.com/jborden)

Please do not hesitate to contact me if you need help using these scripts. Let me know if you find them useful or have hacked them for other purposes. You can also contact me if you want the modified ChemSol 2.1 program that has command-line options for custom input and output filenames that **submitd.pl** requires for Langevin Dipole (LD) calculations.
