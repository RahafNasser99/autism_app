import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:autism_mobile_app/presentation/views/family_views/plan/plan.dart';
import 'package:autism_mobile_app/presentation/views/child_views/login/login.dart';
import 'package:autism_mobile_app/presentation/cubits/login_cubits/login_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/waiting_screen.dart';
import 'package:autism_mobile_app/presentation/views/family_views/mail/all_mails.dart';
import 'package:autism_mobile_app/presentation/views/family_views/plan/plan_list.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/reports.dart';
import 'package:autism_mobile_app/presentation/views/family_views/notes/note_list.dart';
import 'package:autism_mobile_app/presentation/widgets/child_bottom_navigation_bar.dart';
import 'package:autism_mobile_app/presentation/views/family_views/pep_3/pep_3_list.dart';
import 'package:autism_mobile_app/presentation/views/child_views/login/login_start.dart';
import 'package:autism_mobile_app/presentation/widgets/family_bottom_navigation_bar.dart';
import 'package:autism_mobile_app/presentation/views/family_views/plan/plan_target.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/inbox_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/needs/needs_home_page.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/all_plans_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/crud_note_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_needs/child_needs.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_target_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/notes_cubits/cubit/notes_list_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/plan_cubits/cubit/plan_domains_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/pep_3_cubits/cubit/pep_3_tests_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/center_home_exercise/bravo.dart';
import 'package:autism_mobile_app/presentation/cubits/exercise_cubits/cubit/time_exercise_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/time_exercise/all_time_exercise.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_profile/update_passwords.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/plan_report/plan_report.dart';
import 'package:autism_mobile_app/presentation/cubits/edit_profile_cubits/cubit/edit_profile_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/need_section_cubits/cubit/need_section_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_profile/edit_child_profile.dart';
import 'package:autism_mobile_app/presentation/cubits/mails_cubits/cubit/get_un_read_messages_cubit.dart';
import 'package:autism_mobile_app/presentation/views/child_views/child_profile/child_profile_screen.dart';
import 'package:autism_mobile_app/presentation/views/family_views/daily_program/family_daily_program.dart';
import 'package:autism_mobile_app/presentation/cubits/daily_program_cubits/cubit/daily_program_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/update_password_cubits/cubit/update_password_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/child_profile/child_profile_family_control.dart';
import 'package:autism_mobile_app/presentation/cubits/get_child_profile_cubits/cubit/get_child_profile_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/needs_report/need_expression_report.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/waiting_time_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_handle_cubit.dart';
import 'package:autism_mobile_app/presentation/cubits/needs_expression_cubits/cubit/need_expression_report_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/teachers_specialists/teachers_specialists_list.dart';
import 'package:autism_mobile_app/presentation/cubits/teachers_specialists_cubits/cubit/teachers_specialists_cubit.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/time_exercise_report/time_exercise_report.dart';
import 'package:autism_mobile_app/presentation/views/family_views/reports/center_home_tasks_report/center_tasks_report.dart';
import 'package:autism_mobile_app/presentation/cubits/time_cubits/time_exercise_report/cubit/time_exercise_report_cubit.dart';

class AppRoute {
  // final GlobalKey<NavigatorState> navigatorKey;

  // AppRoute({required this.navigatorKey});

  Route onGenerateRoute(RouteSettings settings, bool isAuthenticated) {
    switch (settings.name) {
      //----------------- Login Pages -----------------//
      case '/':
        return !isAuthenticated
            ? MaterialPageRoute(
                builder: (_) => const LoginStart(),
              )
            : _generateRoute(
                BlocProvider<WaitingTimeCubit>(
                  create: (context) => WaitingTimeCubit(),
                  child: const ChildBottomNavigationBar(),
                ),
                settings,
              );
      case '/login-screen':
        return _generateRoute(
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(),
            child: const Login(),
          ),
          settings,
        );

      //----------------- Home pages -----------------//
      case '/child-home-page-screen':
        return _generateRoute(
          BlocProvider<WaitingTimeCubit>(
            create: (context) => WaitingTimeCubit(),
            child: const ChildBottomNavigationBar(),
          ),
          settings,
        );
      case '/family-home-page-screen':
        return _generateRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider<GetChildProfileCubit>(
                create: (context) => GetChildProfileCubit(),
              ),
              BlocProvider<GetUnReadMessagesCubit>(
                create: (context) => GetUnReadMessagesCubit(),
              ),
            ],
            child: const FamilyBottomNavigationBar(),
          ),
          settings,
        );

      //----------------- Profile -----------------//
      case '/child-profile-screen':
        return MaterialPageRoute(
          builder: (_) => BlocProvider<GetChildProfileCubit>(
            create: (context) => GetChildProfileCubit(),
            child: const ChildProfileScreen(),
          ),
        );
      case '/child-profile-family-control-screen':
        return _generateRoute(
          BlocProvider<GetChildProfileCubit>(
            create: (context) => GetChildProfileCubit(),
            child: const ChildProfileFamilyControl(),
          ),
          settings,
        );
      case '/edit-child-profile-screen':
        return PageTransition(
          child: BlocProvider(
            create: (context) => EditProfileCubit(),
            child: const EditChildProfile(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 500),
          settings: settings,
        );
      case '/update-passwords-screen':
        return _generateRoute(
          BlocProvider<UpdatePasswordCubit>(
            create: (context) => UpdatePasswordCubit(),
            child: const UpdatePasswords(),
          ),
          settings,
        );

      //----------------- Teachers & Specialists -----------------//
      case '/teachers-specialists-list-screen':
        return _generateRoute(
          BlocProvider<TeachersSpecialistsCubit>(
            create: (context) => TeachersSpecialistsCubit(),
            child: const TeachersSpecialistsList(),
          ),
          settings,
        );

      //----------------- Needs -----------------//
      case '/needs-screen':
        return PageTransition(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<NeedSectionCubit>(
                create: (context) => NeedSectionCubit(),
              ),
              BlocProvider<NeedExpressionHandleCubit>(
                create: (context) => NeedExpressionHandleCubit(),
              ),
              BlocProvider<GetChildProfileCubit>(
                create: (context) => GetChildProfileCubit(),
              ),
            ],
            child: const NeedsHomePage(),
          ),
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 500),
          settings: settings,
        );
      case '/child-needs-screen':
        return _generateRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider<NeedExpressionReportCubit>(
                create: (context) => NeedExpressionReportCubit(),
              ),
              BlocProvider<NeedExpressionHandleCubit>(
                create: (context) => NeedExpressionHandleCubit(),
              ),
            ],
            child: const ChildNeeds(),
          ),
          settings,
        );

      //----------------- PEP-3 -----------------//
      case '/pep-3-list-screen':
        return _generateRoute(
          BlocProvider<Pep3TestsCubit>(
            create: (context) => Pep3TestsCubit(),
            child: const Pep3List(),
          ),
          settings,
        );

      //----------------- Plan -----------------//
      case '/plan-screen':
        return _generateRoute(const Plans(), settings);
      case '/current-plan-screen':
        return _generateRoute(
          BlocProvider<PlanTargetCubit>(
            create: (context) => PlanTargetCubit(),
            child: const PlanTarget(),
          ),
          settings,
        );
      case '/all-plans-screen':
        return _generateRoute(
          BlocProvider<AllPlansCubit>(
            create: (context) => AllPlansCubit(),
            child: const PlanList(),
          ),
          settings,
        );

      //----------------- Center & Home Exercise -----------------//
      case '/bravo-screen':
        return PageTransition(
          child: const Bravo(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: const Duration(seconds: 1),
        );

      //----------------- Daily Program -----------------//
      case '/daily-program-screen':
        return _generateRoute(
          BlocProvider<DailyProgramCubit>(
            create: (context) => DailyProgramCubit(),
            child: const FamilyDailyProgram(),
          ),
          settings,
        );

      //----------------- Time Exercise -----------------//
      case '/all-time-exercise-screen':
        return _generateRoute(
          BlocProvider<TimeExerciseCubit>(
            create: (context) => TimeExerciseCubit(),
            child: const AllTimeExercise(),
          ),
          settings,
        );
      case '/waiting-screen':
        return _generateRoute(const WaitingScreen(), settings);

      //----------------- Reports -----------------//
      case '/reports-screen':
        return _generateRoute(const Reports(), settings);
      case '/need-expression-report-screen':
        return _generateRoute(
          BlocProvider<NeedExpressionReportCubit>(
            create: (context) => NeedExpressionReportCubit(),
            child: const NeedExpressionReport(),
          ),
          settings,
        );
      case '/center-tasks-report-screen':
        return _generateRoute(const CenterTasksReport(), settings);
      case '/plan-report-screen':
        return _generateRoute(
          BlocProvider<PlanDomainsCubit>(
            create: (context) => PlanDomainsCubit(),
            child: const PlanReport(),
          ),
          settings,
        );
      case '/time-exercise-report-screen':
        return _generateRoute(
          BlocProvider<TimeExerciseReportCubit>(
            create: (context) => TimeExerciseReportCubit(),
            child: const TimeExerciseReport(),
          ),
          settings,
        );

      //----------------- Notes -----------------//
      case '/notes-screen':
        return _generateRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider<NotesListCubit>(
                create: (context) => NotesListCubit(),
              ),
              BlocProvider<CrudNoteCubit>(
                create: (context) => CrudNoteCubit(),
              ),
            ],
            child: const NoteList(),
          ),
          settings,
        );

      //----------------- Mails -----------------//
      case '/all-mails-screen':
        return _generateRoute(
          BlocProvider<InboxCubit>(
            create: (context) => InboxCubit(),
            child: const AllMails(),
          ),
          settings,
        );

      default:
        // navigatorKey.currentState?.pushNamedAndRemoveUntil(
        //   '/login-screen',
        //   (route) => route is Login,
        // );
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const Login(),
          ),
        );
    }
  }

  PageTransition _generateRoute(Widget page, RouteSettings settings) {
    return PageTransition(
      child: page,
      settings: settings,
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 500),
    );
  }
}


// PageTransition(
      //   child: BlocProvider<WaitingTimeCubit>(
      //     create: (context) => WaitingTimeCubit(),
      //     child: const ChildBottomNavigationBar(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: BlocProvider<LoginCubit>(
      //     create: (context) => LoginCubit(),
      //     child: const Login(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: BlocProvider<WaitingTimeCubit>(
      //     create: (context) => WaitingTimeCubit(),
      //     child: const ChildBottomNavigationBar(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      
        // PageTransition(
        //   child: MultiBlocProvider(
        //     providers: [
        //       BlocProvider<GetChildProfileCubit>(
        //         create: (context) => GetChildProfileCubit(),
        //       ),
        //       BlocProvider<GetUnReadMessagesCubit>(
        //         create: (context) => GetUnReadMessagesCubit(),
        //       ),
        //     ],
        //     child: const FamilyBottomNavigationBar(),
        //   ),
        //   type: PageTransitionType.rightToLeft,
        // );

        // PageTransition(
      //   child: BlocProvider<GetChildProfileCubit>(
      //     create: (context) => GetChildProfileCubit(),
      //     child: const ChildProfileFamilyControl(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: BlocProvider<UpdatePasswordCubit>(
      //       create: (context) => UpdatePasswordCubit(),
      //       child: const UpdatePasswords()),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: BlocProvider<TeachersSpecialistsCubit>(
      //     create: (context) => TeachersSpecialistsCubit(),
      //     child: const TeachersSpecialistsList(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: MultiBlocProvider(
      //     providers: [
      //       BlocProvider<NeedExpressionReportCubit>(
      //         create: (context) => NeedExpressionReportCubit(),
      //       ),
      //       BlocProvider<NeedExpressionHandleCubit>(
      //         create: (context) => NeedExpressionHandleCubit(),
      //       ),
      //     ],
      //     child: const ChildNeeds(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      //   settings: settings,
      // );

      // PageTransition(
      //   child: BlocProvider<Pep3TestsCubit>(
      //     create: (context) => Pep3TestsCubit(),
      //     child: const Pep3List(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: const Plans(),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      // PageTransition(
      //   child: BlocProvider<PlanTargetCubit>(
      //     create: (context) => PlanTargetCubit(),
      //     child: const PlanTarget(),
      //   ),
      //   settings: settings,
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );
      
      
      
      // PageTransition(
      //   child: BlocProvider<AllPlansCubit>(
      //     create: (context) => AllPlansCubit(),
      //     child: const PlanList(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      
      // PageTransition(
      //   child: BlocProvider<DailyProgramCubit>(
      //     create: (context) => DailyProgramCubit(),
      //     child: const FamilyDailyProgram(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );


      // PageTransition(
      //   child: BlocProvider<TimeExerciseCubit>(
      //     create: (context) => TimeExerciseCubit(),
      //     child: const AllTimeExercise(),
      //   ),
      //   type: PageTransitionType.scale,
      //   alignment: Alignment.center,
      //   duration: const Duration(seconds: 1),
      // );

      
      // PageTransition(
      //   child: const WaitingScreen(),
      //   type: PageTransitionType.scale,
      //   alignment: Alignment.center,
      //   duration: const Duration(seconds: 1),
      // );


      // PageTransition(
      //   child: const Reports(),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      //   settings: settings,
      // );

        // PageTransition(
      //   child: BlocProvider<NeedExpressionReportCubit>(
      //     create: (context) => NeedExpressionReportCubit(),
      //     child: const NeedExpressionReport(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      //   settings: settings,
      // );

      
      // PageTransition(
      //   child: const CenterTasksReport(),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      
      // PageTransition(
      //   child: BlocProvider<PlanDomainsCubit>(
      //     create: (context) => PlanDomainsCubit(),
      //     child: const PlanReport(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );
      
      
      // PageTransition(
      //   child: BlocProvider<TimeExerciseReportCubit>(
      //     create: (context) => TimeExerciseReportCubit(),
      //     child: const TimeExerciseReport(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );


      // PageTransition(
      //   child: MultiBlocProvider(
      //     providers: [
      //       BlocProvider<NotesListCubit>(
      //         create: (context) => NotesListCubit(),
      //       ),
      //       BlocProvider<CrudNoteCubit>(
      //         create: (context) => CrudNoteCubit(),
      //       ),
      //     ],
      //     child: const NoteList(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );

      
      // PageTransition(
      //   child: BlocProvider<InboxCubit>(
      //     create: (context) => InboxCubit(),
      //     child: const AllMails(),
      //   ),
      //   type: PageTransitionType.rightToLeft,
      //   duration: const Duration(milliseconds: 500),
      // );


      