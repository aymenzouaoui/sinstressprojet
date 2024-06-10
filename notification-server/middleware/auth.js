const jwt = require('jsonwebtoken');




const auth = (req, res, next) => {
  try {
    // Check if the Authorization header exists
    const authHeader = req.header('Authorization');
    if (!authHeader) {
      return res.status(401).json({ message: 'Authorization header missing, authorization denied' });
    }
console.log(authHeader)
    // Extract the token from the Authorization header
    const token = authHeader.split(' ')[1]; // Split on space to get the token
    if (!token) {
      return res.status(401).json({ message: 'No token provided, authorization denied' });
    }

    // Verify the token using the JWT_SECRET from environment variables
    const decoded = jwt.verify(token, "your_jwt_secret");
    
    // Attach the decoded user information to the request object
    req.user = decoded.user; // Assuming decoded token contains a `user` object

    // Proceed to the next middleware or route handler
    next();
  } catch (error) {
    console.error('Token verification failed:', error.message); // Log detailed error
    res.status(401).json({ message: 'Token is not valid' });
  }
};

module.exports = auth;
