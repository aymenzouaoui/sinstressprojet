const Sinistre = require('../models/Sinistre');

// Create a new sinistre
exports.createSinistre = async (req, res) => {
  try {
    const userId = req.user.id;
    const sinistre = new Sinistre(req.body);
    sinistre.userId=userId;
    console.log(sinistre)
    await sinistre.save();
    res.status(201).json(sinistre);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all sinistres
exports.getSinistres = async (req, res) => {
    try {
      // Extract the user ID from req.user
      const userId = req.user.id; // Ensure this matches how you set req.user
      console.log('User ID:', userId);
  
      // Find sinistres by user ID and populate the user details
      const sinistres = await Sinistre.find({ userId }).populate('userId');
      console.log('Sinistres:', sinistres);
  
      // Send the response with the found sinistres
      res.status(200).json(sinistres);
    } catch (error) {
      // Handle any errors
      res.status(400).json({ error: error.message });
    }
  };
  

// Get a sinistre by ID
exports.getSinistreById = async (req, res) => {
  try {
    const sinistre = await Sinistre.findById(req.params.id).populate('userId');
    if (!sinistre) {
      return res.status(404).json({ error: 'Sinistre not found' });
    }
    res.status(200).json(sinistre);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Update a sinistre by ID
exports.updateSinistre = async (req, res) => {
  try {
    const sinistre = await Sinistre.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!sinistre) {
      return res.status(404).json({ error: 'Sinistre not found' });
    }
    res.status(200).json(sinistre);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Delete a sinistre by ID
exports.deleteSinistre = async (req, res) => {
  try {
    const sinistre = await Sinistre.findByIdAndDelete(req.params.id);
    if (!sinistre) {
      return res.status(404).json({ error: 'Sinistre not found' });
    }
    res.status(200).json({ message: 'Sinistre deleted successfully' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
