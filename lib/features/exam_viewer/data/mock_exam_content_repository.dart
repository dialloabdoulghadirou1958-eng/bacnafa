import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

abstract class ExamContentRepository {
  Future<ExamContent?> getExamById(String id);
}

class MockExamContentRepository implements ExamContentRepository {
  @override
  Future<ExamContent?> getExamById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (id != 'math-2026-sm') return null;

    return ExamContent(
      id: 'math-2026-sm',
      title: 'Épreuve de Mathématiques',
      subjectName: 'Mathématiques',
      series: 'Sciences Mathématiques',
      year: '2026',
      session: 'Principale',
      duration: '4 heures',
      coefficient: 9.0,
      sections: [
        ExamSection(
          id: 'sec1',
          title: 'Première Partie : Analyse',
          content: 'L\'élève doit traiter les exercices suivants en utilisant les propriétés des fonctions numériques.',
          order: 1,
          exercises: [
            ExamExercise(
              id: 'ex1',
              number: 1,
              statement: r'Étudier la convergence de la suite $(u_n)$ définie par $u_{n+1} = \sqrt{2 + u_n}$.',
              points: 4.0,
              attachments: [],
            ),
            ExamExercise(
              id: 'ex2',
              number: 2,
              statement: r"Calculer l'intégrale $\int_0^1 x^2 e^x dx$.",
              points: 6.0,
              attachments: ['img_integral_1.png'],
            ),
          ],
        ),
        ExamSection(
          id: 'sec2',
          title: 'Deuxième Partie : Algèbre',
          content: 'Questions sur les espaces vectoriels et les applications linéaires.',
          order: 2,
          exercises: [
            ExamExercise(
              id: 'ex3',
              number: 3,
              statement: r'Montrer que la famille $\mathcal{B} = (e_1, e_2, e_3)$ forme une base de $\mathbb{R}^3$.',
              points: 5.0,
              attachments: [],
            ),
            ExamExercise(
              id: 'ex4',
              number: 4,
              statement: r'Résoudre le système linéaire suivant : $x + y + z = 6, 2x - y + z = 3, x + 2y - z = 2$.',
              points: 5.0,
              attachments: [],
            ),
          ],
        ),
      ],
    );
  }
}
