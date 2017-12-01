var chalk = require('chalk');
var async = require('async');
var mock = require('mock-data');

var rInt = mock.integer;
var rStr = mock.string;
var rDate = mock.date;

var intGen = rInt(1, 100);
var strGen = rStr(4, 10, 'Aa');
var dateGen = rDate(2010, 2017, false, "YYYY-MM")

//const retInt = intGen.generate(2);
const retStr = strGen.generate(10000);
//const retDateTime = dateGen.generate(2);

//console.log(retInt, retStr, retDateTime);
console.log('Generated...OK');

const connection = require('./database')['dev'];
const pgp = require('pg-promise')();

const Client = require('pg').Client;
const client = new Client(connection);

var objectsTaksk = {
  clearTable: (done) => {
    client.query('DELETE from \"nir-object\"', (err) => {
      if (err) done(err);
      console.log(chalk.green(('Objects...Cleared...OK'));
      done(null);
    });
  },
  fillTable: (done) => {

    // our set of columns, to be created only once, and then shared/reused,
    // to let it cache up its formatting templates for high performance:
    const cs = new pgp.helpers.ColumnSet(['name'], {
      table: 'nir-object'
    });

    const values = retStr.map((item) => {
      return {
        name: item
      };
    });

    // generating a multi-row insert query:
    const query = pgp.helpers.insert(values, cs);
    //=> INSERT INTO "tmp"("name") VALUES('..'),...,('...')

    client.query(query, (err, res) => {
      if (err) done(err);
      console.log(chalk.green('Objects...Filled...OK'));
      done(null);
    });
  }
};

var linksTasks = {
  clearTable: (done) => {
    client.query('DELETE from \"nir-link\"', (err) => {
      if (err) done(err);
      console.log(chalk.green('Links...Cleared...OK'));
      done(null);
    });
  },
  fillTable: (done) => {
    client.query('INSERT INTO \"nir-link\" (obj1, obj2, type) SELECT * FROM insert_links(10000)', (err) => {
      if (err) done(err);
      console.log(chalk.green('Objects...Filled...OK'));
      done(null);
    });
  }
};

client.connect((err) => {
  if (err) console.log(chalk.red('Connection error...', err));

  if (!err) {

    async.series([
      (done) => {
        async.series(objectsTaksk, (err, results) => {
          if (err) done(err);
          done(null);
          console.log(chalk.green('Objects...Done...OK'));
        });
      },
      (done) => {
        async.series(linksTasks, (err, results) => {
          if (err) done(err);
          done(null);
          console.log(chalk.green('Links...Done...OK'));
        });
      }
    ], (err, results) => {
      if (err) console.log(chalk.red(err));
      client.end();
      if(!err) console.log(chalk.green('Done...OK'));
    });

  }

});