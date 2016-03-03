# `.ebuild` for PropertyGuru Postgres modules

This contains the ebuild and Manifest for the
postgres modules.

## Known problems

Because the actual code is in a private repo, the 
`SRC_URI` doesn't actually point to anything. It
also doesn't make sense to use an `EGIT_REPO_URI`.

To generate a new version of the module you will
need to do the following:

```
export PV="<new_version>"
export PN="postgres-pg_modules"
git clone <git_uri_for_the_modules> ${PN}-${PV}
tar cvfz ${PN}-${PV}.tar.gz ${PN}-${PV}/
<deploy result archive to /usr/portage/disfiles>
cd /usr/local/portage/dev-db/${PN}
cp <most_recent_ebuild> ${PN}-${PV}.ebuild
ebuild ${PN}-${PV}.ebuild clean manifest
```

If `/usr/local/portage` is a git repo, you will probably
want to update upstream. In the same folder:
```
git add .
git commit -m "Updated the source code for the postgres modules"
git push <ref spec>
```
