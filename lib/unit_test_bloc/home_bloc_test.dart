import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lolo_bloc/application/bloc/dashboard/home/home_bloc.dart';
import 'package:lolo_bloc/domain/dashbaord/home/gender_list_response.dart';
import 'package:lolo_bloc/domain/dashbaord/home/home_response.dart';
import 'package:lolo_bloc/infrastructure/dashboard/home/home_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  DashboardResponse dashboardResponse = DashboardResponse(
    banners: [
      Banners(id: 1, bannerImage: "test", bannerName: "test"),
      Banners(id: 2, bannerImage: "test2", bannerName: "test2"),
      Banners(id: 3, bannerImage: "test3", bannerName: "test3")
    ],
    categorisation: [

    ],
  );
  List<Genders>? genders = [
    Genders(id: 1, title: "Gents", isSelected: false),
    Genders(id: 2, title: "Ladies", isSelected: false),
    Genders(id: 1, title: "Kids", isSelected: false)
  ];
  HomeResponse homeResponse =
      HomeResponse(result: dashboardResponse, message: "success", status: true);
  GenderListResponse genderListResponse =
      GenderListResponse(status: "true", message: "success", genders: genders);

  MockHomeRepository? mockHomeRepository;

  setUp(() async {
    registerFallbackValue(Uri());
    mockHomeRepository = MockHomeRepository();
  });
  blocTest('emits ',
    act: <HomeBloc>(homeBloc) => homeBloc?.add(const GetHomeResult()),
    expect: () {
      return [
        const HomeState(
            isLoading: true,
            isError: false,
            homeResponse: null,
            genderListResponse: null),
        HomeState(
            isLoading: true,
            isError: false,
            homeResponse: homeResponse,
            genderListResponse: null),
        HomeState(
            isLoading: false,
            isError: false,
            homeResponse: homeResponse,
            genderListResponse: genderListResponse)
      ];
    },
    build: () {
      when(() => mockHomeRepository?.getHomeResult()).thenAnswer((_) async {
        return Right(homeResponse);
      });
      when(() => mockHomeRepository?.getGenderResult()).thenAnswer((_) async {
        return Right(genderListResponse);
      });
      return HomeBloc(mockHomeRepository!);
    },
  );
}
