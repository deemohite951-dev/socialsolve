# from django.db import models

# Create your models here.
from django.db import models
from django.conf import settings

class Issue(models.Model):
    STATUS_CHOICES = (
        ('reported', 'Reported'),
        ('in_review', 'In Review'),
        ('in_progress', 'In Progress'),
        ('resolved', 'Resolved'),
    )

    CATEGORY_CHOICES = (
        ('roads', 'Roads & Infrastructure'),
        ('sanitation', 'Garbage & Sanitation'),
        ('water', 'Water Supply'),
        ('electricity', 'Electricity & Power'),
        ('other', 'Other'),
    )

    title = models.CharField(max_length=200)
    description = models.TextField()
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES, default='other')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='reported')
    location = models.CharField(max_length=255, help_text="Street address or landmark")
    image = models.ImageField(upload_to='issues/', null=True, blank=True)
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='reported_issues')
    upvotes = models.ManyToManyField(settings.AUTH_USER_MODEL, related_name='upvoted_issues', blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"[{self.get_status_display()}] {self.title}"