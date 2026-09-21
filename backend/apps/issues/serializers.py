from rest_framework import serializers
from .models import Issue
from apps.authentication.serializers import UserSerializer

class IssueSerializer(serializers.ModelSerializer):
    author = UserSerializer(read_only=True)
    upvotes_count = serializers.IntegerField(source='upvotes.count', read_only=True)
    is_upvoted = serializers.SerializerMethodField()

    class Meta:
        model = Issue
        fields = [
            'id', 'title', 'description', 'category', 'status', 
            'location', 'image', 'author', 'upvotes_count', 
            'is_upvoted', 'created_at', 'updated_at'
        ]
        read_only_fields = ['status', 'created_at', 'updated_at']

    def get_is_upvoted(self, obj):
        user = self.context.get('request').user
        if user.is_authenticated:
            return obj.upvotes.filter(id=user.id).exists()
        return False

class CreateIssueSerializer(serializers.ModelSerializer):
    class Meta:
        model = Issue
        fields = ['id', 'title', 'description', 'category', 'location', 'image']

    def create(self, validated_data):
        validated_data['author'] = self.context['request'].user
        return super().create(validated_data)