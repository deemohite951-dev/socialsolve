# from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import Issue

@admin.register(Issue)
class IssueAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'status', 'author', 'created_at')
    list_filter = ('status', 'category', 'created_at')
    search_fields = ('title', 'description', 'location', 'author__username')
    list_editable = ('status',)
    readonly_fields = ('created_at', 'updated_at')