const mongoose = require('mongoose');

const sinistreSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  photos: {
    type: [String],
    required: true,
  },
  dateReported: {
    type: Date,
    required: true,
  },
  car: {
    make: String,
    model: String,
    year: Number,
    licensePlate: String,
  },
}, { timestamps: true });

module.exports = mongoose.model('Sinistre', sinistreSchema);
