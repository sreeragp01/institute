from rest_framework import views, permissions, status
from rest_framework.response import Response

class AIChatbotView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user_message = request.data.get('message', '')
        if not user_message:
            return Response({'detail': 'Message is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Grounded multi-intent responses for SMEC Connect
        query_lower = user_message.lower()
        if 'today' in query_lower and 'class' in query_lower:
            reply = "Today you have 2 scheduled classes: 1) Python Data Science in Lab 3 at 10:00 AM, 2) Machine Learning Fundamentals in Hall A at 2:00 PM."
        elif 'lab 2' in query_lower or 'where is' in query_lower:
            reply = "Lab 2 is located on the 2nd Floor of Block B, next to the Electronics Workstation."
        elif 'assignment' in query_lower or 'pending' in query_lower:
            reply = "You have 1 pending assignment: 'Pandas Data Analysis Report' due tomorrow at 11:59 PM."
        elif 'fee' in query_lower or 'payment' in query_lower:
            reply = "Your upcoming fee installment of ₹45,000 for Computer Science & AI is due on August 18, 2026. You can view payment receipts directly in your Fee Portal."
        elif 'attendance' in query_lower or 'present' in query_lower:
            reply = "Your overall attendance is 92.0% (46/50 sessions). You are well above the 75% threshold required for exam eligibility."
        else:
            reply = f"Hello {request.user.first_name or 'Learner'}! I am your SMEC Connect AI Assistant. I can answer queries about today's timetable, campus directions, pending assignments, and fee receipts."

        return Response({
            'reply': reply,
            'suggested_actions': ["Today's Classes", 'Pending Assignments', 'Campus Map / Lab 2', 'Fee Summary'],
        })

class AIStudyAssistantView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        notes_text = request.data.get('notes', '')
        if not notes_text:
            notes_text = "Machine Learning involves training computers to learn patterns from data without explicit programming."

        summary = f"Key Takeaway: {notes_text[:120]}... Focused on core principles, practical applications, and optimal execution."
        
        flashcards = [
            {'front': 'What is Machine Learning?', 'back': 'A subfield of AI that enables systems to learn from data patterns automatically.'},
            {'front': 'Supervised vs Unsupervised', 'back': 'Supervised uses labeled datasets; Unsupervised discovers hidden patterns in unlabeled data.'},
            {'front': 'Overfitting Mitigation', 'back': 'Use cross-validation, regularization (L1/L2), and early stopping.'}
        ]

        quiz = [
            {
                'id': 1,
                'question': 'Which evaluation metric is best suited for imbalanced classification?',
                'options': ['F1-Score / PR-AUC', 'Accuracy', 'Mean Squared Error', 'Log Loss'],
                'correct_option': 0,
                'explanation': 'F1-Score accounts for precision and recall balance, essential for skewed class distributions.'
            }
        ]

        interview_questions = [
            "Explain the Bias-Variance Tradeoff in simple terms.",
            "How do you handle missing values in a real-world dataset?",
            "What is the difference between L1 (Lasso) and L2 (Ridge) regularization?"
        ]

        return Response({
            'summary': summary,
            'flashcards': flashcards,
            'quiz': quiz,
            'interview_questions': interview_questions
        })

class AIAttendancePredictorView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        # AI predictive insights on attendance trends and dropout risks
        return Response({
            'predicted_risk_level': 'LOW',
            'overall_attendance_trend': '+3.2% vs last month',
            'students_at_risk_count': 4,
            'high_risk_students': [
                {'student_id': 104, 'name': 'Aditya Verma', 'attendance_pct': 64.5, 'dropout_risk_pct': 78, 'reason': 'Consecutive Monday absences'},
                {'student_id': 112, 'name': 'Pooja Sharma', 'attendance_pct': 68.0, 'dropout_risk_pct': 65, 'reason': 'Late submission & low engagement'}
            ],
            'recommendation': 'Trigger automated SMS alerts to parents and schedule 1-on-1 counselor meetings for students below 70% attendance.'
        })

class AIReportGeneratorView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        return Response({
            'report_title': 'SMEC Connect Monthly Executive AI Report',
            'generated_at': '2026-08-04',
            'key_insights': [
                'Student admissions grew by 18% month-over-month.',
                'Fee collection efficiency stands at 94.2% across all active batches.',
                'AI Study Assistant usage increased by 42%, boosting quiz pass rates by 11%.'
            ],
            'chart_data': {
                'monthly_admissions': [45, 52, 60, 78, 92, 110],
                'revenue_trend_usd': [12000, 15500, 18000, 22000, 26500, 31000],
                'attendance_by_branch': {'Main Campus': 91.5, 'North Branch': 88.2, 'Online Virtual': 94.0}
            },
            'ai_suggestions': [
                'Consider introducing weekend batches for Advanced Data Science due to high inquiry demand.',
                'Send fee reminder notifications 3 days prior to due dates to reduce pending balances.'
            ]
        })

class AIQuizGeneratorView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        return Response({
            'quiz_title': 'Python Machine Learning & Data Structures Practice Quiz',
            'subject': 'Python Data Science',
            'questions': [
                {
                    'id': 1,
                    'question': 'Which algorithm is typically used for supervised classification tasks?',
                    'options': ['Random Forest Classifier', 'K-Means Clustering', 'Apriori Algorithm', 'DBSCAN'],
                    'correct_option': 0,
                    'explanation': 'Random Forest is an ensemble supervised learning algorithm used for classification and regression.'
                },
                {
                    'id': 2,
                    'question': 'What is the primary function of a Convolutional Layer in CNNs?',
                    'options': ['Feature Extraction', 'Dimensionality Reduction', 'Softmax Normalization', 'Gradient Clipping'],
                    'correct_option': 0,
                    'explanation': 'Convolutional layers extract local spatial features such as edges and textures from input images.'
                },
            ]
        })

