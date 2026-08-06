-- test_sqlite.lua
package.cpath = package.cpath .. ";./lib/?.so"
local sqlite3 = require("lsqlite3")
print(sqlite3)

local db = sqlite3.open("test.db")
db:exec("CREATE TABLE IF NOT EXISTS test (id INTEGER, val TEXT)")
db:exec("INSERT INTO test VALUES (1, 'hello')")

for row in db:nrows("SELECT * FROM test") do
    print(row.id, row.val)
end

db:close()
