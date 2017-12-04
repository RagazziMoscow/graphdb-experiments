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
  return db.createTable('nir-link', {
    link_id: {
      type: 'int',
      primaryKey: true,
      autoIncrement: true,
      notNull: true
    },
    obj1: {
      type: 'int',
      foreignKey: {
        name: 'nir-object_nir-link_obj1_fk',
        table: 'nir-object',
        rules: {
          onDelete: 'CASCADE',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    obj2: {
      type: 'int',
      foreignKey: {
        name: 'nir-object_nir-link_obj2_fk',
        table: 'nir-object',
        rules: {
          onDelete: 'CASCADE',
          onUpdate: 'RESTRICT'
        },
        mapping: 'id'
      }
    },
    type: {
      type: 'string'
    },
    string_value: {
      type: 'string'
    }
  });
};

exports.down = function(db) {
  return db.removeTable('nir-link');
};

exports._meta = {
  "version": 1
};