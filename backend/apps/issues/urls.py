from django.urls import path
from .views import IssueListCreateView, IssueStatsView, UpvoteIssueView

urlpatterns = [
    path('', IssueListCreateView.as_view(), name='issue_list_create'),
    path('stats/', IssueStatsView.as_view(), name='issue_stats'),
    path('<int:pk>/upvote/', UpvoteIssueView.as_view(), name='issue_upvote'),
]