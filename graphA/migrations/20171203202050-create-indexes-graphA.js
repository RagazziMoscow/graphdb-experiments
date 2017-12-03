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
  return db.addIndex('int', 'int_index_link_id', ['link_id'], true)
    .then((result) => {
      db.addIndex('string', 'string_index_link_id', ['link_id'], true)
        .then((result) => {
          db.addIndex('real', 'real_index_link_id', ['link_id'], true)
            .then((result) => {
              db.addIndex('binary', 'binary_index_link_id', ['link_id'], true);
            });
        });
    });
};

exports.down = function(db) {
  return db.removeIndex('int', 'int_index_link_id')
    .then((result) => {
      db.removeIndex('string', 'string_index_link_id')
        .then((result) => {
          db.removeIndex('real', 'real_index_link_id')
            .then((result) => {
              db.removeIndex('binary', 'binary_index_link_id');
            });
        });
    });
};

exports._meta = {
  "version": 1
};