import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastosrecorrentes/components/bill_details/installment_components/installment_card.dart';
import 'package:gastosrecorrentes/models/bill.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/remote/api_response.dart';
import 'package:gastosrecorrentes/services/remote/firestore_service.dart';
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
      viewModel.setListBills(ApiResponse.completed([billToTest]));

      expect(viewModel.listBills.data!.length == 1, true);
      expect(viewModel.listBills.data![0] == billToTest, true);
    });
  });

  group('Test generateBillInstallments Method:', () {
    test('Should apply installments to currentBillInstallments', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill();
      viewModel.setCurrentSelectedBill = billToTest;
      List<Installment> installments = viewModel.generateBillInstallments(billToTest);
      expect(viewModel.currentSelectedBill == billToTest, true);
      expect(installments.length == 10, true);
    });

    test('currentbill has 0 ammountMonths should generate difference months from start +2', () async {
      BillsViewModel viewModel = BillsViewModel(fireStoreService: FireStoreService());
      Bill billToTest = createMockBill().copyWith(ammountMonths: 0);

      DateTime dateAux = DateTime.fromMillisecondsSinceEpoch(billToTest.startDate!);
      LocalDate start = LocalDate(dateAux.year, dateAux.month, billToTest.monthlydueDay!);
      Period diff = LocalDate.today().periodSince(start);

      viewModel.setCurrentSelectedBill = billToTest;
      List<Installment> installments = viewModel.generateBillInstallments(billToTest);
      expect(viewModel.currentSelectedBill == billToTest, true);
      expect(installments.length == diff.months + 2, true);
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

      expect(viewModel.listBills.data!.contains(billToTest), true);
      expect(viewModel.listBills.data!.length == 1, true);
      verify(fakeFireStore.setBilltoInactive(any)).called(1);
    });

    test('Should return empty list when userId doesnt exist', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId'))).thenAnswer((_) async => []);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      await viewModel.getRegisteredBills('123');

      expect(viewModel.listBills.data!.isEmpty, true);
      verifyNever(fakeFireStore.setBilltoInactive(any));
    });
  });
  group('Test addNewBill Method:', () {
    test('Should update listBills with new bill', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);
      Bill billToTest = createMockBill();

      when(fakeFireStore.addBill(any)).thenAnswer((_) async => null);

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

      expect(viewModel.listBills.data!.contains(billToTest), true);
      expect(viewModel.listBills.data!.length == 1, true);
      verify(fakeFireStore.setBilltoInactive(any)).called(1);
    });
  });

  group('Test payInstallment Method:', () {
    test('Should update exact installment to paid equals true', () async {
      MockFireStoreService fakeFireStore = MockFireStoreService();
      BillsViewModel viewModel = BillsViewModel(fireStoreService: fakeFireStore);
      BuildContext context = MockBuildContext();
      Bill billToTest = createMockBill();
      Installment installment = createMockInstallment();
      InstallmentCard installmentCard = InstallmentCard(animation: MockAnimation(), index: 1, installment: installment);

      billToTest.installments = [installment];
      viewModel.currentSelectedBill = billToTest;

      when(fakeFireStore.getRegisteredBills(userId: anyNamed('userId')))
          .thenAnswer((_) async => [billToTest, billToTest.copyWith(ammountMonths: 1)]);

      when(fakeFireStore.setBilltoInactive(any)).thenAnswer((_) async => null);

      when(fakeFireStore.updateBill(any)).thenAnswer((_) async => null);

      await viewModel.payInstallment(context, installmentCard, '123');

      expect(viewModel.listBills.data!.contains(billToTest), true);
      expect(viewModel.listBills.data!.length == 1, true);
      expect(
        viewModel.currentSelectedBill!.installments!
            .where((element) => element.dueDate == installment.dueDate && element.isPaid)
            .isNotEmpty,
        true,
      );

      verify(fakeFireStore.setBilltoInactive(any)).called(1);
      verify(fakeFireStore.updateBill(any)).called(1);
    });
  });
}

Installment createMockInstallment() {
  DateTime now = DateTime.now();
  return Installment(
    id: '1',
    dueDate: DateTime(now.year, now.month, now.day),
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
    installments: [],
  );
}

class MockBuildContext extends Mock implements BuildContext {}

class MockAnimation extends Mock implements Animation<double> {}
