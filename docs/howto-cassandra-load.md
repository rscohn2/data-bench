# Loading the Cassandra Database

The Cassandra database needs to be loaded with data before the
transactions can successfully execute.

In the future we expect this method to become obsolete, but for now
this is how we recommend loading the Cassandra database.

0. **Log into the cassandra container**

	```
	$ kubectl exec cassandra-0 -it -- /bin/bash
	```

	
0. **Run the Database Build Script**

	The second argument is the path location of the flat files used to
	populate the database. Future directions will include loading the
	data from a URL (like https://github.com/Data-Bench/data-bench-data/).
     
	```
	$ /var/lib/cassanda/BUILD/databench_build.sh --all /var/lib/cassandra/flat
	```
	
	You can also perform the build operations in seperate steps, but
	the '--all' option will combine them for you, e.g.
	
	```
	$ ./databench_build.sh --create
	$ ./databench_build.sh --load /var/lib/cassandra/flat
	$ ./databench_build.sh --drop
	```
	
0. **Verify Cassandra is Loaded Successfully**
