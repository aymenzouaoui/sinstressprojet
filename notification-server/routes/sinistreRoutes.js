const express = require('express');
const router = express.Router();
const sinistreController = require('../controllers/sinistreController');
const auth = require('../middleware/auth');

router.post('/', auth, sinistreController.createSinistre);
router.get('/', auth, sinistreController.getSinistres);
router.get('/:id', auth, sinistreController.getSinistreById);
router.put('/:id', auth, sinistreController.updateSinistre);
router.delete('/:id', auth, sinistreController.deleteSinistre);

module.exports = router;
