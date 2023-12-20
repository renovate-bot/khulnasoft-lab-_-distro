package factory

import (
	"github.com/khulnasoft-lab/distro/db"
	"github.com/khulnasoft-lab/distro/db/bolt"
	"github.com/khulnasoft-lab/distro/db/sql"
	"github.com/khulnasoft-lab/distro/util"
)

func CreateStore() db.Store {
	config, err := util.Config.GetDBConfig()
	if err != nil {
		panic("Can not read configuration")
	}
	switch config.Dialect {
	case util.DbDriverMySQL:
		return &sql.SqlDb{}
	case util.DbDriverBolt:
		return &bolt.BoltDb{}
	case util.DbDriverPostgres:
		return &sql.SqlDb{}
	default:
		panic("Unsupported database dialect: " + config.Dialect)
	}
}
