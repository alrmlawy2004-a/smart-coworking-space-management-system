import 'dart:io';

Future<void> main() async {
  WorkspaceManager manager = WorkspaceManager();

  while (true) {
    print("\n====== Smart Co-Working Space System ======");
    print("1. Register Customer");
    print("2. Search Customer");
    print("3. Display Customers");
    print("4. Add Customer Balance");
    print("5. Add Workspace");
    print("6. Remove Workspace");
    print("7. Display All Workspaces");
    print("8. Search Workspace");
    print("9. Display Workspaces by Type");
    print("10. Display Available Workspaces");
    print("11. Create Booking");
    print("12. Search Booking");
    print("13. Display All Bookings");
    print("14. Display Customer Bookings");
    print("15. Confirm Booking");
    print("16. Cancel Booking");
    print("17. Complete Booking");
    print("18. Process Payment");
    print("19. Display Reports");
    print("20. Exit");

    stdout.write("Enter your choice: ");

    String? input = stdin.readLineSync();

    // إنهاء البرنامج إذا أُغلق مصدر الإدخال
    if (input == null) {
      print("\nGoodbye!");
      return;
    }

    int? choice = int.tryParse(input.trim());

    try {
      switch (choice) {
        case 1:
          manager.CustomerManagement();
          break;

        case 2:
          manager.searchCustomer();
          break;

        case 3:
          manager.displayCustomers();
          break;

        case 4:
          manager.addCustomerBalance();
          break;

        case 5:
          manager.WorkspaceManagement();
          break;

        case 6:
          manager.removeWorkspace();
          break;

        case 7:
          manager.displayWorkspace();
          break;

        case 8:
          manager.searchWorkspace();
          break;

        case 9:
          manager.displayWorkspacesByType();
          break;

        case 10:
          manager.displayAvailableWorkspaces();
          break;

        case 11:
          manager.createBooking();
          break;

        case 12:
          manager.searchBooking();
          break;

        case 13:
          manager.displayAllBookings();
          break;

        case 14:
          manager.displayCustomerBookings();
          break;

        case 15:
          await manager.confirmBooking();
          break;

        case 16:
          manager.cancelBooking();
          break;

        case 17:
          manager.completeBooking();
          break;

        case 18:
          manager.processPayment();
          break;

        case 19:
          manager.displayReports();
          break;

        case 20:
          print("Goodbye!");
          return;

        default:
          print("Error: Choose a number from 1 to 20.");
      }
    } on FormatException {
      print("Error: Invalid number. Please try again.");
    }
  }
}

class Customer {
  int CustomerID;
  String FullName;
  String PhoneNumber;
  double AccountBalance;

  Customer(
    this.CustomerID,
    this.FullName,
    this.PhoneNumber,
    this.AccountBalance,
  ) {}
}

class Workspace {
  int WorkspaceID;
  String WorkspaceName;
  String WorkspaceType;
  double HourlyRate;
  bool AvailabilityStatus;

  Workspace(
    this.WorkspaceID,
    this.WorkspaceName,
    this.WorkspaceType,
    this.HourlyRate,
    this.AvailabilityStatus,
  ) {}
}

class Booking {
  int bookingID;
  Customer customer;
  Workspace workspace;
  DateTime bookingDate;
  int startTime;
  double durationHours;
  double totalCost;
  String bookingStatus;
  String paymentStatus;

  Booking(
    this.bookingID,
    this.customer,
    this.workspace,
    this.bookingDate,
    this.startTime,
    this.durationHours,
    this.totalCost,
    this.bookingStatus,
    this.paymentStatus,
  ) {
    totalCost = workspace.HourlyRate * durationHours;
    bookingStatus = "Pending";
    paymentStatus = "Unpaid";
  }
}

class WorkspaceManager {
  List<Customer> customer = [];
  List<Workspace> workspace = [];
  List<Booking> booking = [];
  List<String> paymentStatus = [];

  void CustomerManagement() {
    print("Add a new customer");
    stdout.write("Enter customer ID");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Customer ID must be a positive integer.");
      return;
    }

    for (var a in customer) {
      if (a.CustomerID == id) {
        print("Error: Customer number already exists");
        return;
      }
    }
    stdout.write("Enter customer full name");
    String name = (stdin.readLineSync() ?? "").trim();
    if (name.isEmpty) {
      print("The name field must not be left empty.");
      return;
    }
    stdout.write("Enter The phone number");
    String phone = (stdin.readLineSync() ?? "").trim();
    if (phone.isEmpty) {
      print("The phone number field must not be left empty.");
      return;
    }
    stdout.write("Enter the balance");
       double? balance = double.tryParse(stdin.readLineSync() ?? "");
    if (balance == null || balance < 0) {
      print("Error: Balance must be a valid non-negative number.");
      return;
    }

    if (balance < 0) {
      print("Error: You cannot enter a negative balance.");
      return;
    }

    customer.add(Customer(id, name, phone, balance));
  }

  void displayCustomers() {
    print(" All Customers");
    if (customer.isEmpty) {
      print("No customers found.");
      return;
    }
    for (var c in customer) {
      print(
        "ID: ${c.CustomerID} | Name: ${c.FullName} | Phone: ${c.PhoneNumber} | Balance: ${c.AccountBalance}",
      );
    }
  }

  void WorkspaceManagement() {
    print("Add a new workspace");
    stdout.write("Enter workspace ID");
    int? id_wor = int.tryParse(stdin.readLineSync()??"");
     if (id_wor == null || id_wor <= 0) {
      print("Error: Workspace ID must be a positive integer.");
      return;
    }

    for (var b in workspace) {
      if (b.WorkspaceID == id_wor) {
        print("Error: workspace number already exists");
        return;
      }
    }
    stdout.write("Enter workspace full name");
    String name_wor =( stdin.readLineSync() ?? "").trim();
    if (name_wor.isEmpty) {
      print("The workspace field must not be left empty.");
      return;
    }
// التحقق من ان المستخدم سوف يدخل المساحة ضمن الملطوب 
          stdout.write("Enter Type (Desk, Private Office, Meeting Room): ");
    String type = (stdin.readLineSync() ?? "").trim();
    const validTypes = ["desk", "private office", "meeting room"];
    if (!validTypes.contains(type.toLowerCase())) {
      print("Error: Invalid type. Use Desk, Private Office, or Meeting Room.");
      return;
    }

    print("Enter Hourly Rate: ");
    double? rate = double.tryParse(stdin.readLineSync() ?? "");
    if (rate == null || rate <= 0) {
      print("Error: Rate must be a number greater than zero.");
      return;
    }
    workspace.add(Workspace(id_wor, name_wor, type, rate, true));
  }

  void displayWorkspace() {
    print(" All Customers");
    if (workspace.isEmpty) {
      print("No workspace found.");
      return;
    }
    for (var w in workspace) {
      print(
        "ID: ${w.WorkspaceID} | Name: ${w.WorkspaceName} | Type: ${w.WorkspaceType} | Rate: ${w.HourlyRate}/hr | Available: ${w.AvailabilityStatus}",
      );
    }
  }

  void removeWorkspace() {
    print("Remov workspace");
    stdout.write("Enter workspace ID to remov");
    int? id_wor = int.tryParse(stdin.readLineSync()??"");

    if(id_wor == null || id_wor <=0){
            print("Error: Workspace ID must be a positive integer.");
return;
    }
    bool Reservation = false;
    for (var o in booking) {
      if (o.workspace.WorkspaceID == id_wor &&
          (o.bookingStatus == "Pending" || o.bookingStatus == "Confirmed")) {
        Reservation = true;
        break;
      }
    }
    if (Reservation) {
      print("Error: There are existing bookings.");
      return;
    }
    bool removed = false;
    workspace.removeWhere((w) {
      if (w.WorkspaceID == id_wor) {
        removed = true;
        return true;
      }
      return false;
    });
    if (removed) {
      print("Workspace removed successfully");
    } else {
      print("Error: Workspace ID not found");
    }
  }

  void addCustomerBalance() {
    print("Add customer Balancce");
    stdout.write("Enter customer ID");
    int? id = int.tryParse(stdin.readLineSync()??"");

     if (id == null || id <= 0) {
      print("Error: Customer ID must be a positive integer.");
      return;
    }

    Customer? targetCustomer;
    for (var c in customer) {
      if (c.CustomerID == id) {
        targetCustomer = c;
        break;
      }
    }
    if (targetCustomer == null) {
      print("Error: Customer not found");
      return;
    }
    stdout.write("Enter amunt to add:");
    double? amunt = double.tryParse(stdin.readLineSync() ?? "");
    if (amunt == null || amunt <= 0) {
      print("Error: Enter a valid amount greater than zero.");
      return;
    }
    targetCustomer.AccountBalance += amunt;
    print(
      "Balance updated successfully. New balance: ${targetCustomer.AccountBalance}",
    );
  }

  void searchCustomer() {
    stdout.write("Enter customer ID: ");
    //تم استخدام tryParse حتى لا يتوقف البرنامج اذا ادخل المستخدم نص
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("Error: Enter a valid integer ID");
      return;
    }
    for (var c in customer) {
      if (c.CustomerID == id) {
        print(
          "ID: ${c.CustomerID}  | Name: ${c.FullName} | phone: ${c.PhoneNumber} | Balance:${c.AccountBalance}",
        );
        return;
      }
    }

    print("Error: Customer not found");
  }

  void searchWorkspace() {
    stdout.write("Enter Workspace ID: ");
    //تم استخدام tryParse حتى لا يتوقف البرنامج اذا ادخل المستخدم نص
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null) {
      print("Error: Enter a valid integer ID");
      return;
    }
    for (var w in workspace) {
      if (w.WorkspaceID == id) {
        print(
          "ID: ${w.WorkspaceID}  | Name: ${w.WorkspaceName} | Type: ${w.WorkspaceType} |Rate: ${w.HourlyRate}/hr | Available: ${w.AvailabilityStatus}",
        );
        return;
      }
    }

    print("Error: Workspace not found");
  }

  //عرض المساحات حسب النوع
  void displayWorkspacesByType() {
    stdout.write("Enter type (Desk, Private Office, Meeting Room):");
    String type = (stdin.readLineSync() ?? "").trim().toLowerCase();

    const validTypes = ["desk", "private office", "meeting room"];
    if (!validTypes.contains(type)) {
      print("Error: Invalid workspace type");
      return;
    }
    var resulte = workspace.where((w) {
      return w.WorkspaceType.trim().toLowerCase() == type;
    });

    if (resulte.isEmpty) {
      print("No workspaces found for this type");
      return;
    }
    for (var w in resulte) {
      print(
        "ID: ${w.WorkspaceID}  | Name: ${w.WorkspaceName} | Type: ${w.WorkspaceType} | Rate: ${w.HourlyRate}/hr | Available: ${w.AvailabilityStatus}",
      );
    }
  }

  //عرض المساحات المتاحة فقط
  void displayAvailableWorkspaces() {
    var resulte = workspace.where((w) => w.AvailabilityStatus == true);
    if (resulte.isEmpty) {
      print("No workspaces found for this type");
      return;
    }
    for (var w in resulte) {
      print(
        "ID: ${w.WorkspaceID}  | Name: ${w.WorkspaceName} | Type: ${w.WorkspaceType} | Rate: ${w.HourlyRate}/hr | Available: ${w.AvailabilityStatus}",
      );
    }
  }

  void createBooking() {
    stdout.write("Enter booking ID:");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Booking ID must be a positive integer");
      return;
    }
    //هذا الجزء يتأكد أن رقم الحجز الجديد غير مستخدم مسبقًا
    for (var b in booking) {
      if (b.bookingID == id) {
        print("Error: Booking ID already exists");
        return;
      }
    }
    // البحث عن عميل
    stdout.write("Enter customer ID");
    int? customerID = int.tryParse(stdin.readLineSync() ?? "");
    if (customerID == null || customerID <= 0) {
      print("Error: customer ID must be a positive integer");
      return;
    }

    Customer? selectedCustomer;

    for (var c in customer) {
      if (c.CustomerID == customerID) {
        selectedCustomer = c;
        break;
      }
    }
    if (selectedCustomer == null) {
      print("Error: Customer not found");
      return;
    }
    //البحث  عن المساحة
    stdout.write("Enter workspace ID");
    int? workspaceID = int.tryParse(stdin.readLineSync() ?? "");
    if (workspaceID == null || workspaceID <= 0) {
      print("Error: workspace ID must be a positive integer");
      return;
    }

    Workspace? selectedWorkspace;

    for (var w in workspace) {
      if (w.WorkspaceID == workspaceID) {
        selectedWorkspace = w;
        break;
      }
    }
    if (selectedWorkspace == null) {
      print("Error: workspace not found");
      return;
    }

    // لتحديد التاريخ
    stdout.write("Enter booking date ");
    String date = (stdin.readLineSync() ?? "").trim();

    //عشان نحدد طريقة كتابة التاريخ
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
      print("Error: Use YYYY-MM-DD.");
      return;
    }

    DateTime? dat = DateTime.tryParse(date);

    //  dat.toIso8601String().substring(0, 10) عشان نحول التاريخ الي نص وناخد اول عشرة جزء منه
    if (dat == null || dat.toIso8601String().substring(0, 10) != date) {
      print("Error: Invalid booking date.");
      return;
    }

    //لتحديد الوقت
    stdout.write("Enter start time");
    int? time = int.tryParse(stdin.readLineSync() ?? "");
    if (time == null || time < 0 || time > 2359) {
      print("Error: Invalid start time");
      return;
    }
    int hour = time ~/ 100;
    int minute = time % 100;
    if (minute > 59) {
      print("Minutes must be between 00 and 59");
      return;
    }

    //عشان ندمج التاريخ بالوقت
    DateTime start = DateTime(dat.year, dat.month, dat.day, hour, minute);

    // نحدد مدة الحجز
    stdout.write("Enter duration in hours");
    double? hours = double.tryParse(stdin.readLineSync() ?? "");

    if (hours == null || hours <= 0) {
      print("Error: Duration must be a positive number");
      return;
    }
    // لحتويل الساعات الى دقائق

    double minutes = hours * 60;

    if (!minutes.isFinite || minutes < 1 || minutes > 525600) {
      print("Error: Duration must be between 1 minute and 365 days");
      return;
    }
    //لتقريب الوقت الى اقرب عد صحيح
    int min = minutes.round();
    double actualHours = min / 60.0;

    DateTime end = start.add(Duration(minutes: min));

    for (var b in booking) {
      bool sameWorkspace =
          b.workspace.WorkspaceID == selectedWorkspace.WorkspaceID;

      bool active =
          b.bookingStatus == "Pending" || b.bookingStatus == "Confirmed";
      if (!sameWorkspace || !active) {
        continue;
      }
      int existingHour = b.startTime ~/ 100;
      int existingMinute = b.startTime % 100;
      DateTime existingStart = DateTime(
        b.bookingDate.year,
        b.bookingDate.month,
        b.bookingDate.day,
        existingHour,
        existingMinute,
      );

      DateTime existingEnd = existingStart.add(
        Duration(minutes: (b.durationHours * 60).round()),
      );

      bool overlaps = start.isBefore(existingEnd) && end.isAfter(existingStart);

      if (overlaps) {
        print("Error: This workspace is already booked at that time.");
        return;
      }
    }

    // انشاء الحجز وحفظه
    Booking newBooking = Booking(
      id,
      selectedCustomer,
      selectedWorkspace,
      dat,
      time,
      actualHours,
      0.0,
      "Pending",
      "Uunpaid",
    );
    booking.add(newBooking);
    updateWorkspaceAvailability(selectedWorkspace);

    String displayedTime =
        "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}";

    print("Booking created successfully.");
    print("Booking ID: ${newBooking.bookingID}");
    print("Customer: ${newBooking.customer.FullName}");
    print("Workspace: ${newBooking.workspace.WorkspaceName}");
    print("Date: $date");
    print("Start time: $displayedTime");
    print("Duration: ${newBooking.durationHours} hours");
    print("Total cost: ${newBooking.totalCost.toStringAsFixed(2)}");
    print("Booking status: ${newBooking.bookingStatus}");
    print("Payment status: ${newBooking.paymentStatus}");
  }
  // تفاصيل الحجز

  void displayBookingDetails(Booking b) {
    String date = b.bookingDate.toIso8601String().substring(0, 10);

    int hour = b.startTime ~/ 100;
    int minute = b.startTime % 100;

    String time =
        "${hour.toString().padLeft(2, '0')}:"
        "${minute.toString().padLeft(2, '0')}";

    print("Booking ID: ${b.bookingID}");
    print("Customer: ${b.customer.FullName}");
    print("Workspace: ${b.workspace.WorkspaceName}");
    print("Date: $date");
    print("Start time: $time");
    print("Duration: ${b.durationHours} hours");
    print("Total cost: ${b.totalCost.toStringAsFixed(2)}");
    print("Booking status: ${b.bookingStatus}");
    print("Payment status: ${b.paymentStatus}");
  }

  // البحث عن الحجز بزاسطة الرقم
  void searchBooking() {
    stdout.write("Enter booking ID");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Booking ID must be a positive integer");
      return;
    }
    for (var b in booking) {
      if (b.bookingID == id) {
        displayBookingDetails(b);
        return;
      }
    }
    print("Error: Booking not found");
  }

  //عرض جميع الحجوزات
  void displayAllBookings() {
    if (booking.isEmpty) {
      print("No bookings found");
      return;
    }
    for (var b in booking) {
      displayBookingDetails(b);
    }
  }

  // عرض حجوزات عميل معين
  void displayCustomerBookings() {
    stdout.write("Enter customer ID");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Customer ID must be a positive integer");
      return;
    }

    bool customerExists = false;
    for (var c in customer) {
      if (c.CustomerID == id) {
        customerExists = true;
        break;
      }
    }
    if (!customerExists) {
      print("Error: Customer not found.");
      return;
    }
    // عشان نجمع حجوزات العميل
    List<Booking> resulte = [];
    for (var b in booking) {
      if (b.customer.CustomerID == id) {
        resulte.add(b);
      }
    }
    if (resulte.isEmpty) {
      print("This customer has no bookings");
      return;
    }
    for (var b in resulte) {
      displayBookingDetails(b);
    }
  }

  void updateWorkspaceAvailability(Workspace targetWorkspace) {
    bool hasActiveBooking = false;

    for (var b in booking) {
      bool sameWorkspace =
          b.workspace.WorkspaceID == targetWorkspace.WorkspaceID;

      bool active =
          b.bookingStatus == "Pending" || b.bookingStatus == "Confirmed";

      if (sameWorkspace && active) {
        hasActiveBooking = true;
        break;
      }
    }

    targetWorkspace.AvailabilityStatus = !hasActiveBooking;
  }

  //لتاكيد الحجز
  Future<void> confirmBooking() async {
    stdout.write("Enter booking ID: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Invalid booking ID.");
      return;
    }

    Booking? targetBooking;

    for (var b in booking) {
      if (b.bookingID == id) {
        targetBooking = b;
        break;
      }
    }

    if (targetBooking == null) {
      print("Error: Booking not found.");
      return;
    }

    if (targetBooking.bookingStatus != "Pending") {
      print("Error: Only pending bookings can be confirmed.");
      return;
    }

    print("Checking workspace availability...");
    await Future.delayed(Duration(seconds: 2));

    // إعادة التحقق بعد الانتظار
    if (targetBooking.bookingStatus != "Pending") {
      print("Error: Booking is no longer pending.");
      return;
    }

    DateTime start = DateTime(
      targetBooking.bookingDate.year,
      targetBooking.bookingDate.month,
      targetBooking.bookingDate.day,
      targetBooking.startTime ~/ 100,
      targetBooking.startTime % 100,
    );

    DateTime end = start.add(
      Duration(minutes: (targetBooking.durationHours * 60).round()),
    );

    for (var b in booking) {
      // لا نقارن الحجز بنفسه
      if (b.bookingID == targetBooking.bookingID) {
        continue;
      }

      bool sameWorkspace =
          b.workspace.WorkspaceID == targetBooking.workspace.WorkspaceID;

      bool active =
          b.bookingStatus == "Pending" || b.bookingStatus == "Confirmed";

      if (!sameWorkspace || !active) {
        continue;
      }

      DateTime existingStart = DateTime(
        b.bookingDate.year,
        b.bookingDate.month,
        b.bookingDate.day,
        b.startTime ~/ 100,
        b.startTime % 100,
      );

      DateTime existingEnd = existingStart.add(
        Duration(minutes: (b.durationHours * 60).round()),
      );

      if (start.isBefore(existingEnd) && end.isAfter(existingStart)) {
        print("Error: Workspace is booked at that time.");
        return;
      }
    }

    targetBooking.bookingStatus = "Confirmed";
    updateWorkspaceAvailability(targetBooking.workspace);

    print("Booking confirmed successfully.");
  }

  void cancelBooking() {
    stdout.write("Enter booking ID: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Invalid booking ID.");
      return;
    }

    Booking? targetBooking;

    for (var b in booking) {
      if (b.bookingID == id) {
        targetBooking = b;
        break;
      }
    }

    if (targetBooking == null) {
      print("Error: Booking not found.");
      return;
    }

    if (targetBooking.bookingStatus != "Pending" &&
        targetBooking.bookingStatus != "Confirmed") {
      print("Error: Only pending or confirmed bookings can be cancelled.");
      return;
    }

    targetBooking.bookingStatus = "Cancelled";
    updateWorkspaceAvailability(targetBooking.workspace);

    print("Booking cancelled successfully.");
  }

  void completeBooking() {
    stdout.write("Enter booking ID: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Invalid booking ID.");
      return;
    }

    Booking? targetBooking;

    for (var b in booking) {
      if (b.bookingID == id) {
        targetBooking = b;
        break;
      }
    }

    if (targetBooking == null) {
      print("Error: Booking not found.");
      return;
    }

    if (targetBooking.bookingStatus != "Confirmed") {
      print("Error: Only confirmed bookings can be completed.");
      return;
    }

    targetBooking.bookingStatus = "Completed";
    updateWorkspaceAvailability(targetBooking.workspace);

    print("Booking completed successfully.");
  }

  List<Map<String, Object>> paymentRecords = [];
  void processPayment() {
    //  إدخال رقم الحجز
    stdout.write("Enter booking ID: ");
    int? id = int.tryParse(stdin.readLineSync() ?? "");

    if (id == null || id <= 0) {
      print("Error: Booking ID must be a positive integer.");
      return;
    }

    // البحث عن الحجز
    Booking? targetBooking;

    for (var b in booking) {
      if (b.bookingID == id) {
        targetBooking = b;
        break;
      }
    }

    if (targetBooking == null) {
      print("Error: Booking not found.");
      return;
    }

    // 3. التأكد أن الحجز مؤكد
    if (targetBooking.bookingStatus != "Confirmed") {
      print("Error: Only confirmed bookings can be paid.");
      return;
    }

    // 4. منع تكرار الدفع
    if (targetBooking.paymentStatus == "Paid") {
      print("Error: This booking has already been paid.");
      return;
    }

    // 5. التحقق من صحة التكلفة والرصيد
    double cost = targetBooking.totalCost;
    Customer payingCustomer = targetBooking.customer;

    if (!cost.isFinite || cost <= 0) {
      print("Error: Invalid booking cost.");
      return;
    }

    if (!payingCustomer.AccountBalance.isFinite ||
        payingCustomer.AccountBalance < cost) {
      print("Error: Insufficient or invalid account balance.");
      return;
    }

    // 6. تجهيز سجل الدفعة
    Map<String, Object> paymentRecord = {
      "bookingID": targetBooking.bookingID,
      "customerID": payingCustomer.CustomerID,
      "amount": cost,
      "paymentDate": DateTime.now(),
    };

    // 7. تنفيذ الدفع بعد نجاح جميع الفحوص
    payingCustomer.AccountBalance -= cost;
    targetBooking.paymentStatus = "Paid";
    paymentRecords.add(paymentRecord);

    print("Payment completed successfully.");
    print("Paid amount: ${cost.toStringAsFixed(2)}");
    print(
      "Remaining balance: "
      "${payingCustomer.AccountBalance.toStringAsFixed(2)}",
    );
  }

  void displayReports() {
    print("\n========== Reports ==========");

    // 1. عدد العملاء
    print("Total customers: ${customer.length}");

    // 2. عدد المساحات حسب النوع
    Map<String, int> workspaceCounts = {
      "desk": 0,
      "private office": 0,
      "meeting room": 0,
    };

    for (var w in workspace) {
      String type = w.WorkspaceType.trim().toLowerCase();

      workspaceCounts[type] = (workspaceCounts[type] ?? 0) + 1;
    }

    print("\nWorkspaces by type:");

    workspaceCounts.forEach((type, count) {
      print("$type: $count");
    });

    // 3. إجمالي عدد الحجوزات
    print("\nTotal bookings: ${booking.length}");

    // 4. أعداد الحجوزات حسب الحالة
    int confirmed = 0;
    int pending = 0;
    int cancelled = 0;
    int completed = 0;

    for (var b in booking) {
      if (b.bookingStatus == "Pending") {
        pending++;
           } else if (b.bookingStatus == "Confirmed") {
        confirmed++;
      } else if (b.bookingStatus == "Cancelled") {
        cancelled++;
      } else if (b.bookingStatus == "Completed") {
        completed++;
      }
    }

    print("Pending bookings: $pending");
    print("Confirmed bookings: $confirmed");
    print("Cancelled bookings: $cancelled");
    print("Completed bookings: $completed");

    // 5. إجمالي الإيرادات المحصلة من سجلات الدفع
    double totalRevenue = 0;

    for (var payment in paymentRecords) {
      totalRevenue += (payment["amount"] as num).toDouble();
    }

    print("\nTotal revenue: ${totalRevenue.toStringAsFixed(2)}");

    //  المساحة الأكثر حجزًا
    // نحسب جميع سجلات الحجوزات، بما فيها الملغاة
    Map<int, int> bookingCounts = {};
    Map<int, String> workspaceNames = {};

    for (var b in booking) {
      int workspaceId = b.workspace.WorkspaceID;

      bookingCounts[workspaceId] = (bookingCounts[workspaceId] ?? 0) + 1;

      workspaceNames[workspaceId] = b.workspace.WorkspaceName;
    }

    if (bookingCounts.isEmpty) {
      print("\nMost frequently booked workspace: No bookings.");
    } else {
      int highestCount = 0;

      for (var count in bookingCounts.values) {
        if (count > highestCount) {
          highestCount = count;
        }
      }

      print("\nMost frequently booked workspace(s):");

      bookingCounts.forEach((workspaceId, count) {
        if (count == highestCount) {
          print(
            "ID: $workspaceId | "
            "Name: ${workspaceNames[workspaceId]} | "
            "Bookings: $count",
          );
        }
      });
    }

    // 7. عرض الحجوزات غير المدفوعة
    print("\nUnpaid bookings:");

    bool foundUnpaid = false;

    for (var b in booking) {
      if (b.paymentStatus == "Unpaid" && b.bookingStatus != "Cancelled") {
        displayBookingDetails(b);
        foundUnpaid = true;
      }
    }

    if (!foundUnpaid) {
      print("No unpaid bookings.");
    }
  }
}
