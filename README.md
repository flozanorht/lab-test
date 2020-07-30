# Quick and Dirty Lab Script Testing

This will not be needed anymore when we all switch to DynoLabs but in the meantime it might be useful to projects performing quick releases (course bugs, shlib fixes, TLS certificate renewals, minor version bumps).

It is my no means extensive, nor complete, much less bullet proof.
It is just a script that lists all lab scripts available from classroom and runs each of them with `start` and `finish` arguments. 

Its output has to be iterpreted by a course developer to determine which of the reported errors are real.

## Usage

Just run `lab-test-all.sh` from your workstation and wait.

It displays, for each lab script it finds:

```
*** Testing lab script: lab-workers-degrade
***
*** workers-degrade start PASS
*** workers-degrade finish PASS
```

And at the end it displays an overall summary:

```
*** Testing took 00:16.15 hr:min.seg
***
*** Total lab scripts: 33, 61 pass, 5 errors
***
*** List of lab scripts with errors on either start or finish:
*** certificates-app-trust logging-deploy monitor-troubleshoot storage-review template-ansible
```

It also generates a log file `lab-test-all-yymmddhhmm.log` with the fill output of each lab command.

## Caveats

* It depends on lab scripts exiting with a proper shell status

* It only works for labs that are self-contained. It does not know about dependencies.

* Sometimes we require manual steps before a lab script.

* It depens on scripts doing proper clean up. It does not reset the classroom between each lab script.

* It does not test grading.
