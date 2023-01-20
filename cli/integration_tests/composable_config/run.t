Setup
  $ . ${TESTDIR}/../setup.sh
  $ . ${TESTDIR}/setup.sh $(pwd)  
# Build app-a, save output to a file so we can fish out the hash from the logs
# Should not run compile task, since dependsOn is overridden.
  $ ${TURBO} run build --skip-infer --filter=app-a > tmp.log
  $ cat tmp.log
  \xe2\x80\xa2 Packages in scope: app-a (esc)
  \xe2\x80\xa2 Running build in 1 packages (esc)
  \xe2\x80\xa2 Remote caching disabled (esc)
  app-a:build: cache miss, executing 918d3cdc677a3e0e
  app-a:build: 
  app-a:build: > build
  app-a:build: > echo "building app-a" > lib/foo.txt && echo "building app-a" > out/foo.txt
  app-a:build: 
  
   Tasks:    1 successful, 1 total
  Cached:    0 cached, 1 total
    Time:\s*[\.0-9]+m?s  (re)
  
# Look in the saved logs for the hash, so we can inspect the tarball with the same name
  $ HASH=$(cat tmp.log | grep -E "app-a:build.* executing .*" | awk '{print $5}')
  $ tar -tf $TARGET_DIR/node_modules/.cache/turbo/$HASH.tar.zst;
  apps/app-a/.turbo/turbo-build.log
  apps/app-a/lib/
  apps/app-a/lib/.keep
  apps/app-a/lib/foo.txt

# Build app-b, save output to a file so we can fish out the hash from logs
# - Should run `compile`first`
  $ ${TURBO} run build --skip-infer --filter=app-b > tmp.log
  $ cat tmp.log
  \xe2\x80\xa2 Packages in scope: app-b (esc)
  \xe2\x80\xa2 Running build in 1 packages (esc)
  \xe2\x80\xa2 Remote caching disabled (esc)
  app-b:compile: cache miss, executing 55ca1e245673a734
  app-b:compile: 
  app-b:compile: > compile
  app-b:compile: > echo "compiling in app-b"
  app-b:compile: 
  app-b:compile: compiling in app-b
  app-b:build: cache miss, executing 13415565770ebfbe
  app-b:build: 
  app-b:build: > build
  app-b:build: > echo "building app-b" > lib/foo.txt && echo "building app-b" > out/foo.txt
  app-b:build: 
  
   Tasks:    2 successful, 2 total
  Cached:    0 cached, 2 total
    Time:\s*[\.0-9]+m?s  (re)
  
# Look in the saved logs for the hash, so we can inspect the tarball with the same name
  $ HASH=$(cat tmp.log | grep -E "app-b:build.* executing .*" | awk '{print $5}')
  $ tar -tf $TARGET_DIR/node_modules/.cache/turbo/$HASH.tar.zst;
  apps/app-b/.turbo/turbo-build.log
  apps/app-b/out/
  apps/app-b/out/.keep
  apps/app-b/out/foo.txt
