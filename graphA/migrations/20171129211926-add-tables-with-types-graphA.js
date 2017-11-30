'use strict';

var dbm;
var type;
var seed;

/**
  * We receive the dbmigrate dependency from dbmigrate initially.
  * This enables us to not have to rely on NODE_PATH.
  */
exports.setup = function(options, seedLink) {
  dbm = options.dbmigrate;
  type = dbm.dataType;
  seed = seedLink;
};

exports.up = function(db) {
  return db.createTable('int', {
    id: {
      type: 'int',
      primaryKey: true,
      autoIncrement: true,
      notNull: true
    },
    link_id: {
      type: 'int',
      notNull: true,
      foreignKey: {
        name: 'nir-link_int_fk',
        table: 'nir-link',
        rules: {
          onDelete: 'CASCADE',
          onUpdate: 'RESTRICT'
        },
        mapping: {
          link_id: 'link_id'
        }
      }
    },
    value: {
      type: 'int',
      notNull: true,
    }
  }).then((result) => {
    db.createTable('string', {
      id: {
        type: 'int',
        primaryKey: true,
        autoIncrement: true,
        notNull: true
      },
      link_id: {
        type: 'int',
        notNull: true,
        foreignKey: {
          name: 'nir-link_string_fk',
          table: 'nir-link',
          rules: {
            onDelete: 'CASCADE',
            onUpdate: 'RESTRICT'
          },
          mapping: {
            link_id: 'link_id'
          }
        }
      },
      value: {
        type: 'string',
        notNull: true,
      }
    });
  }).then((result) => {
    db.createTable('real', {
      id: {
        type: 'int',
        primaryKey: true,
        autoIncrement: true,
        notNull: true
      },
      link_id: {
        type: 'int',
        notNull: true,
        foreignKey: {
          name: 'nir-link_real_fk',
          table: 'nir-link',
          rules: {
            onDelete: 'CASCADE',
            onUpdate: 'RESTRICT'
          },
          mapping: {
            link_id: 'link_id'
          }
        }
      },
      value: {
        type: 'real',
        notNull: true,
      }
    });
  }).then((result) => {
      db.createTable('binary', {
        id: {
          type: 'int',
          primaryKey: true,
          autoIncrement: true,
          notNull: true
        },
        link_id: {
          type: 'int',
          notNull: true,
          foreignKey: {
            name: 'nir-link_binary_fk',
            table: 'nir-link',
            rules: {
              onDelete: 'CASCADE',
              onUpdate: 'RESTRICT'
            },
            mapping: {
              link_id: 'link_id'
            }
          }
        },
        value: {
          type: 'int',
          notNull: true,
        }
      });
    }).then((result) => {
      db.createTable('date-time', {
        id: {
          type: 'int',
          primaryKey: true,
          autoIncrement: true,
          notNull: true
        },
        link_id: {
          type: 'int',
          notNull: true,
          foreignKey: {
            name: 'nir-link_date-time_fk',
            table: 'nir-link',
            rules: {
              onDelete: 'CASCADE',
              onUpdate: 'RESTRICT'
            },
            mapping: {
              link_id: 'link_id'
            }
          }
        },
        value: {
          type: 'datetime',
          notNull: true,
        }
      });
    });
};

exports.down = function(db) {
  return db.dropTable('int').then(result => {
    db.dropTable('string').then(result => {
      db.dropTable('real').then(result => {
        db.dropTable('binary').then(result => {
          db.dropTable('date-time');
        });
      });
    });
  });
};

exports._meta = {
  "version": 1
};
