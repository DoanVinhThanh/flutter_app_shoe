
import 'package:flutter_/models/address_sqlite.dart';
import 'package:flutter_/models/cart_sqlite.dart';
import 'package:flutter_/models/category_sqlite.dart';
import 'package:flutter_/models/order_detail_sqlite.dart';
import 'package:flutter_/models/order_sqlite.dart';
import 'package:flutter_/models/products_sqlite.dart';
import 'package:flutter_/models/users_sqlite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "ecommerceapp.db";

  //TABLE USER
  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrAvarta TEXT, usrFullname TEXT, usrPhonenumber TEXT, usrEmail TEXT UNIQUE , usrPassword TEXT, usrDate TEXT)";
  //TABLE PRODUCT
  String products =
      "CREATE TABLE products (productId INTEGER PRIMARY KEY AUTOINCREMENT,productImage TEXT,productName TEXT,productDescription TEXT,productPrice TEXT,productSize TEXT,productColor TEXT,productImages TEXT)";
  //TABLE CART
  String cart =
      "CREATE TABLE cart (cartId INTEGER PRIMARY KEY AUTOINCREMENT, cartImage TEXT, cartName TEXT, cartQuantity TEXT, cartPrice TEXT, cartSize TEXT, cartColor TEXT, cartEmailUser TEXT, FOREIGN KEY(cartEmailUser) REFERENCES users(usrEmail))";
  //TABLE CART
  String address =
      "CREATE TABLE address (addressId INTEGER PRIMARY KEY AUTOINCREMENT, addressNameUser TEXT,addressPhone TEXT, addressNumber TEXT, addressStreet TEXT, addressWard TEXT, addressDistrict TEXT, addressCity TEXT,addressStatus BOOLEAN, addressEmailUser TEXT, FOREIGN KEY(addressEmailUser) REFERENCES users(usrEmail))";
  //TABLE CATEGORY
  String categories =
      "create table categories (categoryId INTEGER PRIMARY KEY AUTOINCREMENT, categoryImage TEXT, categoryName TEXT)";
  //TABLE Orders
  // Create the 'orders' table
  String orders = """
  CREATE TABLE orders (
    orderId INTEGER PRIMARY KEY AUTOINCREMENT,
    userEmail TEXT,
    totalAmount REAL,
    address TEXT,
    status TEXT DEFAULT 'Chờ xác nhận',
    orderDate TEXT
  )
""";

// Create the 'order_details' table
  String orderDetails = """
  CREATE TABLE order_details (
    orderDetailId INTEGER PRIMARY KEY AUTOINCREMENT,
    orderId INTEGER,
    productName TEXT,
    productPrice INTEGER,
    quantity INTEGER,
    total INTEGER,
    FOREIGN KEY(orderId) REFERENCES orders(orderId)
  )
""";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 2, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(products);
      await db.execute(cart);
      await db.execute(categories);
      await db.execute(address);
      await db.execute(orders);
      await db.execute(orderDetails);
    });
  }

  //FUNCTION METHOD
  //USER
  Future<bool> emailExists(String email) async {
    final Database db = await initDB();
    var result = await db.query(
      'users',
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  //Sign in
  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.query(
      'users',
      where: 'usrEmail = ? AND usrPassword = ?',
      whereArgs: [user.usrEmail, user.usrPassword],
    );
    return result.isNotEmpty;
  }

  //Sign up
  Future<int> signUp(Users user) async {
    final Database db = await initDB();
    try {
      return await db.insert("users", user.toMap());
    } catch (e) {
      return -1; // Indicate failure
    }
  }

// Forgot password
  Future<bool> forgot(String email, String newPassword) async {
    final Database db = await initDB();

    var result =
        await db.query("users", where: "usrEmail = ?", whereArgs: [email]);

    if (result.isNotEmpty) {
      int updateCount = await db.update(
        "users",
        {"usrPassword": newPassword},
        where: "usrEmail = ?",
        whereArgs: [email],
      );
      return updateCount > 0;
    } else {
      return false;
    }
  }
  //get current user detail

  Future<Users?> getUser(String email) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "usrEmail = ?", whereArgs: [email]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }

  // Update the avatar of the user
  Future<int> updateAvatar(String email, String avatarPath) async {
    final Database db = await initDB();

    return await db.update(
      'users',
      {'usrAvarta': avatarPath},
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
  }

  // Update user information
  Future<int> updateUser(
      String email, String fullname, String phoneNumber, String date) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      {
        'usrFullname': fullname,
        'usrPhonenumber': phoneNumber,
        'usrDate': date,
      },
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
  }

  // Update Name user information
  Future<int> updateNameUser(String email, String fullname) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      {
        'usrFullname': fullname,
      },
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
  }

  // Update Phone user information
  Future<int> updatePhoneUser(String email, String phoneNumber) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      {
        'usrPhonenumber': phoneNumber,
      },
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
  }

  // Update Date user information
  Future<int> updateDateUser(String email, String date) async {
    final Database db = await initDB();
    return await db.update(
      'users',
      {
        'usrDate': date,
      },
      where: 'usrEmail = ?',
      whereArgs: [email],
    );
  }

  //PRODUCT
  // Insert a product
  Future<void> insertProduct(Product product) async {
    final db = await initDB();
    await db.insert('products', product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all products
  Future<List<Product>> getProducts() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    final db = await initDB();
    await db.update(
      'products',
      product.toMap(),
      where: 'productId = ?',
      whereArgs: [product.productId],
    );
  }

  // Delete a product
  Future<void> deleteProduct(int id) async {
    final db = await initDB();
    await db.delete(
      'products',
      where: 'productId = ?',
      whereArgs: [id],
    );
  }

  //CART
  // Insert a product
  Future<void> insertCart(Cart cart) async {
    final db = await initDB();
    await db.insert('cart', cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Cart>> getCartItemsByEmail(String email) async {
    final db = await initDB();
    final List<Map<String, dynamic>> items = await db.query(
      'cart',
      where: 'cartEmailUser = ?',
      whereArgs: [email],
    );
    return items.isNotEmpty ? items.map((e) => Cart.fromMap(e)).toList() : [];
  }

  Future<void> updateCartQuantity(
      String cartEmailUser, int cartName, int newQuantity) async {
    final db = await initDB();
    await db.update(
      'cart',
      {'cartQuantity': newQuantity.toString()}, // Cập nhật số lượng
      where: 'cartEmailUser = ? AND cartId = ?', // Điều kiện để tìm sản phẩm
      whereArgs: [cartEmailUser, cartName],
    );
  }

  Future<void> deleteCartItem(String userEmail, String productName) async {
    final db = await initDB();
    await db.delete(
      'cart', // Tên bảng giỏ hàng
      where: 'cartEmailUser = ? AND cartId = ?',
      whereArgs: [userEmail, productName],
    );
  }

  //CATEGORY
  // Insert a product
  Future<void> insertCategories(Category category) async {
    final db = await initDB();
    await db.insert('categories', category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all products
  Future<List<Category>> getCategories() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Update a product
  Future<void> updateCategories(Category category) async {
    final db = await initDB();
    await db.update(
      'categories',
      category.toMap(),
      where: 'categoryId = ?',
      whereArgs: [category.categoryId],
    );
  }

  // Delete a product
  Future<void> deleteCategories(int id) async {
    final db = await initDB();
    await db.delete(
      'categories',
      where: 'categoryId = ?',
      whereArgs: [id],
    );
  }

  //Search product by category
  Future<List<Product>> getProductsByCategoryName(String categoryName) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where:
          'productName LIKE ?', // Search for products containing the category name
      whereArgs: ['%$categoryName%'],
    );

    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

// Search products by keyword
  Future<List<Product>> searchProductsByKeyword(String keyword) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'productName LIKE ?', // Search for products containing the keyword
      whereArgs: ['%$keyword%'],
    );

    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  // Insert a new address
  Future<void> insertAddress(Address address) async {
    final db = await initDB();
    await db.insert(
      'address',
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing address by its ID
  Future<void> updateAddress(Address address) async {
    final db = await initDB();
    await db.update(
      'address',
      address.toMap(),
      where: 'addressId = ?',
      whereArgs: [address.addressId],
    );
  }

  // Delete an address by its ID
  Future<void> deleteAddress(int addressId) async {
    final db = await initDB();
    await db.delete(
      'address',
      where: 'addressId = ?',
      whereArgs: [addressId],
    );
  }

  // Retrieve all addresses for a specific user by email
  Future<List<Address>> getAddressesByEmail(String email) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'address',
      where: 'addressEmailUser = ?',
      whereArgs: [email],
    );

    return List.generate(maps.length, (i) {
      return Address.fromMap(maps[i]);
    });
  }

  Future<void> updateAddressStatus(int addressId, bool status) async {
    final db = await initDB(); // Ensure the database is available
    await db.update(
      'address', // Your table name
      {'addressStatus': status ? 1 : 0}, // Set status to 1 or 0
      where: 'addressId = ?',
      whereArgs: [addressId],
    );
  }

  // Add this method inside the DatabaseHelper class
  Future<Address?> getSelectedAddressByEmail(String email) async {
    final db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'address',
      where: 'addressEmailUser = ? AND addressStatus = ?',
      whereArgs: [email, 1], // Fetch the address with addressStatus = 1
    );

    // Return the first address found with addressStatus = 1, if any
    return result.isNotEmpty ? Address.fromMap(result.first) : null;
  }

  Future<int> createOrder(Order order) async {
    final db = await initDB();

    // Insert the order and get the order ID
    int orderId = await db.insert('orders', order.toMap());

    // Now, insert the order details for each cart item
    List<Cart> cartItems = await getCartItemsByEmail(order.userEmail);
    for (var item in cartItems) {
      // Tính tổng giá cho mỗi sản phẩm
      int productPrice = int.tryParse(item.cartPrice ?? '0') ?? 0;
      int quantity = int.tryParse(item.cartQuantity ?? '1') ?? 1;
      int totalPrice = productPrice * quantity;

      print(
          'Inserting productPrice: $productPrice, quantity: $quantity, totalPrice: $totalPrice');

      // Tạo đối tượng OrderDetail
      OrderDetail orderDetail = OrderDetail(
        orderId: orderId,
        productName: item.cartName ?? '',
        productPrice: productPrice,
        quantity: quantity,
        total: totalPrice, // Lưu tổng giá trị sản phẩm
      );

      // Thêm chi tiết đơn hàng vào bảng 'order_details'
      await db.insert('order_details', orderDetail.toMap());
    }

    return orderId;
  }

  Future<List<OrderDetail>> getOrderDetailsByOrderId(int orderId) async {
    final db = await initDB(); // Mở database
    final result = await db.query(
      'order_details', // Tên bảng OrderDetail
      where: 'orderId = ?', // Lọc theo orderId
      whereArgs: [orderId],
    );

    // Chuyển đổi kết quả thành danh sách OrderDetail
    return result.map((data) => OrderDetail.fromMap(data)).toList();
  }

  Future<List<Order>> getOrdersByUser(String userEmail) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

// Xóa giỏ hàng sau khi thanh toán
  Future<void> clearCart(String userEmail) async {
    final db = await initDB();
    await db.delete(
      'cart',
      where: 'cartEmailUser = ?',
      whereArgs: [userEmail],
    );
  }

  Future<List<Order>> getOrdersByStatus(String userEmail, String status) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'userEmail = ? AND status = ?',
      whereArgs: [userEmail, status],
    );

    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<List<Order>> getAllOrdersByStatus(String status) async {
    final db = await initDB(); // Initialize the database
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: [status],
    );

    // Map the query result to a list of Order objects
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<void> updateOrderStatus(int orderId, String currentStatus) async {
    final db = await initDB(); // Replace with your database initialization

    String newStatus;

    // Determine the new status based on the current status
    if (currentStatus == 'Chờ xác nhận') {
      newStatus = 'Đang giao';
    } else if (currentStatus == 'Đang giao') {
      newStatus = 'Đã giao';
    } else if (currentStatus == 'Hủy') {
      newStatus = 'Đã hủy';
    } else {
      newStatus =
          currentStatus; // If the status is not in the conditions above, do not change it
    }

    try {
      // Update the order status in the database
      await db.update(
        'orders', // Assuming the table name is 'orders'
        {'status': newStatus},
        where: 'orderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error updating order status: $e');
    }
  }
}
