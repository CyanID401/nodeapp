const express = require('express');
const mongoose = require('mongoose');

const MONGO_HOSTS = JSON.parse(process.env.MONGO_HOSTS) || null;
const MONGO_USER = process.env.MONGO_USER || null;
const MONGO_PASS = process.env.MONGO_PASS || null;

const app = express();

app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: false }));

if (MONGO_HOSTS === null) {
    throw new Error('MONGO_HOSTS environment variable is not set!');
}

if (MONGO_USER === null || MONGO_PASS === null) {
    throw new Error('MONGO_USER or MONGO_PASS environment variable is not set!');
}

const connectionString = MONGO_HOSTS.map(host => `${host}:27017`).join(',');

// Connect to MongoDB
mongoose
  .connect(
    `mongodb://${MONGO_USER}:${MONGO_PASS}@${connectionString}/docker-node-mongo?replicaSet=rs0&authSource=admin`,
    { useNewUrlParser: true }
  )
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err));

const Item = require('./models/item');

app.get('/', (req, res) => {
  Item.find()
    .then(items => res.render('index', { items }))
    .catch(err => res.status(404).json({ msg: 'No items found' }));
});

app.post('/item/add', (req, res) => {
  const newItem = new Item({
    name: req.body.name
  });

  newItem.save().then(item => res.redirect('/'));
});

const port = 3000;

app.listen(port, () => console.log('Server running...'));
