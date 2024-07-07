import 'dart:ui';

Path createCustomShapePath(Size size) {
  // Create the path for the custom shape
  const radius =
      Radius.circular(20.0); // Adjust the radius as per your preference
  // Define the path for the rounded square
  Path path = Path();

  // Move to the starting point at the bottom left corner
  path.moveTo(0, size.height - radius.y);
  // Add a conic curve to the bottom left corner
  path.conicTo(0, size.height, radius.x, size.height, 1);

  // Add a straight line to the bottom right corner
  path.lineTo(size.width * 0.83 - radius.x, size.height);
  // Add a conic curve to the bottom center
  path.conicTo(size.width * 0.83, size.height, size.width * 0.83,
      size.height - radius.y, 1);
  // Add a conic curve on top of the bottom center conic curve
  // x1,y1,x2,y2,w
  path.conicTo(size.width * 0.83, size.height - radius.y * 2,
      (size.width * 0.83) + radius.x, size.height - radius.y * 2, 1);
  // Add a straight line to the bottom right corner

  path.lineTo(size.width - radius.x, size.height - radius.x * 2);
  // Add a conic curve on top of the concave conic curve bottom right corner

  path.conicTo(size.width, size.height - radius.y * 2, size.width,
      size.height - radius.y * 3, 1);

  // Add a straight line to the top right corner
  path.lineTo(size.width, radius.y);
  // Add a conic curve to the top right corner
  path.conicTo(size.width, 0, size.width - radius.x, 0, 1);
  // Add a straight line to the top left corner
  path.lineTo(size.width * 0.5, 0);
  // Add a conic curve to the top left corner
  path.conicTo((size.width * 0.5) - radius.x, 0, size.width * 0.5 - radius.y,
      radius.y, 1);
  path.conicTo(size.width * 0.5 - radius.x, radius.y * 2,
      size.width * 0.5 - radius.x * 2, radius.y * 2, 1);
  path.lineTo(0 + radius.x, radius.x * 2);
  path.conicTo(0, radius.y * 2, 0, radius.y * 3, 1);
  // Close the path
  path.close();

  return path;
}
