## Submission of package version 1.1.2
Initial submission of the package, which provides an interface for the UK's official source of data for COVID-19.

## R CMD check results

1 Note:

```
Possibly mis-spelled words in DESCRIPTION:
  COVID (12:39, 13:36)
  Coronavirus (13:23)
  SDK (12:27)
```
The words are valid, but not matched in a dictionary. They are either known abbreviations or nouns.

Two additional notes were produced on Windows:

```
Found the following (possibly) invalid URLs:
  URL: https://api.coronavirus.data.gov.uk/
    From: README.md
    Status: 404
    Message: Not Found

Found the following (possibly) invalid file URI:
  URI: API documentations
    From: man/get_data.Rd
```
The first concerns the validity of the link. The URL is correct, but requires additional query parameters to produce results. It is included as a reference. 

The second concerns the relative path, highlighting that it does not exist. I cannot reproduce the issue on Windows, however, I have checked and the file does indeed exist.


There were no warnings.

There were no errors.


## Test Environments  

The package has been tested on 4 operating systems:

- Windows Server 2008 R2 SP1, R-devel, 32/64 bit - OK 
- Ubuntu Linux 16.04 LTS, R-release, GCC - OK 
- Fedora Linux, R-devel, clang, gfortran - OK
- Mac OS X 10.14.6, R-release (local) - OK


## Downstream dependencies
All check has status OK.
