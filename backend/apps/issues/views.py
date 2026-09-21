# from django.shortcuts import render

# Create your views here.
from rest_framework import generics, permissions, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from .models import Issue
from .serializers import IssueSerializer, CreateIssueSerializer

class IssueListCreateView(generics.ListCreateAPIView):
    parser_classes = [MultiPartParser, FormParser, JSONParser]
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return CreateIssueSerializer
        return IssueSerializer

    def get_queryset(self):
        status_param = self.request.query_params.get('status')
        queryset = Issue.objects.all()
        if status_param:
            queryset = queryset.filter(status=status_param)
        return queryset

class IssueStatsView(APIView):
    """Provides summary statistics for the 4 cards at the top of the feed."""
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        total = Issue.objects.count()
        in_review = Issue.objects.filter(status='in_review').count()
        in_progress = Issue.objects.filter(status='in_progress').count()
        resolved = Issue.objects.filter(status='resolved').count()

        return Response({
            "total": total,
            "in_review": in_review,
            "in_progress": in_progress,
            "resolved": resolved
        })

class UpvoteIssueView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, pk):
        try:
            issue = Issue.objects.get(pk=pk)
            user = request.user
            if issue.upvotes.filter(id=user.id).exists():
                issue.upvotes.remove(user)
                voted = False
            else:
                issue.upvotes.add(user)
                voted = True
            return Response({"upvoted": voted, "total_upvotes": issue.upvotes.count()})
        except Issue.DoesNotExist:
            return Response({"error": "Issue not found"}, status=status.HTTP_404_NOT_FOUND)