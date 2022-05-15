# Dataset OEX Reviews
This data set is my personal log of running reviews in Open Exchange.   
It is just a table with 555 records and no special features.    
Ready to run experiments on various ways of indexing.   
Personal names of authors are scrambled for this example.   

All data are resulting from the analysis of the OEX web pages.   
The first run collects the URL for the Details pages skipping duplicates    
imposed by the "featured" header block.   
The next run collects updates and details of the packages as available.   
Some informatinon is missing as it gets inserted dynamically over several   
fetch cycles while I have just 1 from IRIS.   
 
A utility to load and update is included. To use these methods you will    
need to create an SSL Configuration named "community" in SMP    
for client access to _community.intersystems.com:443_ .    
This is included in Docker image setup.  

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 
Clone/git pull the repo into any local directory
```
git https://github.com/isc-at/Dataset-OEX-reviews.git
```
Run the IRIS container with your project: 
```
docker-compose up -d --build
```
## How to Test it
Connect to the containers SMP and examine content in namespace USER
applying the decribed examples or use commandline $system.SQL.Shell()     
**[or use Online Demo](https://dataset-oex-reviews.demo.community.intersystems.com/csp/sys/%25CSP.Portal.Home.zen) :**

### Example 1 
- distibution of ratings
```
  SELECT count(id) pkg, stars
  FROM dc_data_rcc.OEX
  group by NVL(stars,-1)
  order by 2 desc
----------------------------------------------
pkg stars
 7   6.0
 1   5.5
 66  5.0
 24  4.5
 14  4.0
 13  3.5
 14  3.0
 6   2.5
 9   2.0
 4   1.5
 4   1.0
 5   0.5
337  0.0
----------------------------------------------
```
### Example 2
- find top rated authors
```
SELECT stars, %exact(author) author
FROM dc_data_rcc.OEX
where stars > 5 group by author order by 1 desc
----------------------------------------------
stars	author
6.0	ZVPUNRY-O_NNZ
6.0	`UdUb0cdUYgUb
6.0	N\PSSH\TL'YVUNPLY
6.0	TY]O*^YWK]*]KV`KNY\
6.0	X[^QZf[,_OMXQ_Q
6.0	ZN_V\-`N[PURg-ZNPVN`
6.0	fXeZXl3`\^[T\_Xa^b
5.5	J[LJS^%XM[FWT[
5.5	HQMXV]$QEWPIRRMOSZ
5.5	rnkb9fZkq9i^k^bkZ9`hf^l
----------------------------------------------
```

[Article in DC](https://community.intersystems.com/post/dataset-oex-reviews)    

[Demo Server SMP](https://dataset-oex-reviews.demo.community.intersystems.com/csp/sys/UtilHome.csp)   
[Demo Server WebTerminal](https://dataset-oex-reviews.demo.community.intersystems.com/terminal/)    
        
**Code Quality**   
<img width="85%" src="https://openexchange.intersystems.com/mp/img/packages/1469/screenshots/vlcp6uzf6ct88l1vgvuv4awhc.jpg">
