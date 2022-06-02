import 'package:flutter_test/flutter_test.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/firestore_service.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:time_machine/time_machine.dart';
import 'package:mockito/annotations.dart';
import 'bills_view_model_unit_test.mocks.dart';

@GenerateMocks([FireStoreService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Test setters Methods:', () {
    test('Should apply new value to currentSelectedBill', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill();
      viewModel.setCurrentSelectedBill = billToTest;

      expect(viewModel.currentSelectedBill == billToTest, true);
    });

    test('Should apply new value to listBills', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill();
      viewModel.setListBills([billToTest]);

      expect(viewModel.listBills.length == 1, true);
      expect(viewModel.listBills[0] == billToTest, true);
    });
  });

  group('Test generateCurrentBillInstallments Method:', () {
    test('Should apply installments to currentBillInstallments', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill();
      viewModel.setCurrentSelectedBill = billToTest;
      viewModel.generateCurrentBillInstallments();
      expect(viewModel.currentSelectedBill == billToTest, true);
      expect(viewModel.currentBillInstallments!.length == 10, true);
      expect(viewModel.currentBillInstallments![viewModel.currentBillInstallments!.length - 1].isPaid, true);
    });

    test('currentbill has 0 ammountMonths should generate difference months from start +1', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill().copyWith(ammountMonths: 0);

      DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(billToTest.startDate!);
      LocalDate start = LocalDate(dateAux.year, dateAux.month, billToTest.monthlydueDay!);
      Period diff = LocalDate.today().periodSince(start);

      viewModel.setCurrentSelectedBill = billToTest;
      viewModel.generateCurrentBillInstallments();
      expect(viewModel.currentSelectedBill == billToTest, true);
      expect(viewModel.currentBillInstallments!.length == diff.months + 1, true);
    });
    test('currentBillInstallments null if currentBill is also null', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      viewModel.generateCurrentBillInstallments();
      expect(viewModel.currentSelectedBill == null, true);
      expect(viewModel.currentBillInstallments == null, true);
    });
  });

  group('Test getRegisteredBills Method:', () {
    test('Should return list of Bills removing finished bills', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);
      Bill billToTest = createMockBill();

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId')))
          .thenAnswer((_) async => [createMockBill(), createMockBill().copyWith(ammountMonths: 1)]);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      await viewModel.getRegisteredBills('123');

      expect(viewModel.listBills.contains(billToTest), true);
      expect(viewModel.listBills.length == 1, true);
      verify(fakeFireStore.setBilltoInactive(any)).called(1);
    });

    test('Should return empty list when userId doesnt exist', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId'))).thenAnswer((_) async => []);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      await viewModel.getRegisteredBills('123');

      expect(viewModel.listBills.isEmpty, true);
      verifyNever(fakeFireStore.setBilltoInactive(any));
    });
  });
  group('Test addNewBill Method:', () {
    test('Should update listBills with new bill', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);
      Bill billToTest = createMockBill();

      when(fakeFireStore.addBill(
        name: anyNamed('name'),
        ammountMonths: anyNamed('ammountMonths'),
        dueDay: anyNamed('dueDay'),
        value: anyNamed('value'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) async => null);

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId')))
          .thenAnswer((_) async => [createMockBill(), createMockBill().copyWith(ammountMonths: 1)]);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      await viewModel.addNewBill(
        name: billToTest.name,
        amountMonths: billToTest.ammountMonths!.toString(),
        dueDay: billToTest.monthlydueDay!.toString(),
        userId: billToTest.userId!,
        value: billToTest.value.toString(),
      );

      expect(viewModel.listBills.contains(billToTest), true);
      expect(viewModel.listBills.length == 1, true);
      verify(fakeFireStore.setBilltoInactive(any)).called(1);
    });
  });

  group('Test payInstallment Method:', () {
    test('Should update exact installment to paid equals true', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);
      Bill billToTest = createMockBill();
      viewModel.currentSelectedBill = billToTest;
      Installment installment = createMockInstallment();

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId')))
          .thenAnswer((_) async => [billToTest, billToTest.copyWith(ammountMonths: 1)]);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      when(fakeFireStore.updateBill(any)).thenAnswer((_) async => null);

      await viewModel.payInstallment(installment, '123');

      expect(viewModel.listBills.contains(billToTest), true);
      expect(viewModel.listBills.length == 1, true);
      expect(viewModel.currentSelectedBill!.payments.containsKey(installment.dueDate.toString()), true);
      verify(fakeFireStore.setBilltoInactive(any)).called(1);
      verify(fakeFireStore.updateBill(any)).called(1);
    });
  });
}

Installment createMockInstallment() {
  return Installment(
    dueDate: DateTime.now().add(const Duration(days: 1)),
    index: 1,
    isLate: false,
    isPaid: false,
    price: 250,
  );
}

Bill createMockBill() {
  DateTime now = DateTime.now();
  return Bill(
    id: '1',
    userId: '123',
    name: 'TestBill',
    ammountMonths: 10,
    isActive: true,
    monthlydueDay: 5,
    startDate: DateTime(now.year, now.month, 1).subtract(const Duration(days: 90)).millisecondsSinceEpoch,
    value: 123,
    barCode: {},
    payments: {
      '${DateTime(now.year, now.month, 5)}': true,
    },
  );
}