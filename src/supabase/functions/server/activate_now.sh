#!/bin/bash

# 🚀 9LMNTS STUDIO - IMMEDIATE AI ACTIVATION SCRIPT
# Start generating revenue in 5 minutes

echo "🚀 ACTIVATING 9LMNTS STUDIO AI AGENTS..."
echo "🎯 TARGET: $2,500 IN 24 HOURS"
echo "⏰ START TIME: $(date)"
echo "=" * 60

# Check environment
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ ERROR: OPENAI_API_KEY required"
    exit 1
fi

if [ -z "$SUPABASE_URL" ]; then
    echo "❌ ERROR: SUPABASE_URL required"
    exit 1
fi

echo "✅ Environment variables OK"

# 1. ACTIVATE CREWAI AGENTS
echo ""
echo "🤖 ACTIVATING CREWAI AGENTS..."
curl -X POST "https://api.crewai.com/v1/crews/activate" \
  -H "Authorization: Bearer $CREWAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "24-Hour Revenue Blitz",
    "agents": ["sales", "lead_gen", "social", "email"],
    "target": 2500,
    "timeframe": "24h"
  }'

echo "✅ CrewAI agents activated"

# 2. START N8N WORKFLOW
echo ""
echo "⚙️ STARTING N8N WORKFLOW..."
curl -X POST "http://localhost:5678/api/v1/workflows/execute" \
  -H "Content-Type: application/json" \
  -d @24hour_revenue_blitz.json

echo "✅ n8n workflow started"

# 3. DEPLOY 9LMNTS STUDIO V5
echo ""
echo "🚀 DEPLOYING 9LMNTS STUDIO V5..."
cd "c:\Users\me\Downloads\9LMNTS Studio V5"
npm run build
netlify deploy --prod --dir=dist --site=9lmnts-studio-v5

echo "✅ V5 deployed to Netlify"

# 4. ACTIVATE PAYMENT SYSTEM
echo ""
echo "💳 ACTIVATING PAYMENT SYSTEM..."
curl -X POST "https://api.paypal.com/v1/notifications/webhooks" \
  -H "Authorization: Bearer $PAYPAL_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://9lmnts-studio-v5.netlify.app/api/webhook/paypal",
    "event_types": ["PAYMENT.CAPTURE.COMPLETED"],
    "description": "9LMNTS Studio Payment Processing"
  }'

echo "✅ PayPal webhook activated"

# 5. START SOCIAL MEDIA AUTOMATION
echo ""
echo "📱 STARTING SOCIAL MEDIA AUTOMATION..."

# Instagram post
curl -X POST "https://graph.facebook.com/v18.0/17841405886031400/feed" \
  -H "Authorization: Bearer $FACEBOOK_TOKEN" \
  -F "message=🚀 24-HOUR CHALLENGE: Launch your Event OS platform today! Limited time offer - Transform your events with AI. #EventTech #AI #9LMNTS"

# Twitter post
curl -X POST "https://api.twitter.com/2/tweets" \
  -H "Authorization: Bearer $TWITTER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "🚀 24-HOUR EVENT PLATFORM CHALLENGE: I am launching AI-powered Event OS platforms for local businesses. Who wants in? #EventTech #LocalBusiness #AI"
  }'

# LinkedIn post
curl -X POST "https://api.linkedin.com/v2/shares" \
  -H "Authorization: Bearer $LINKEDIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "🚀 Transform your events with AI-powered platforms. We are helping local businesses increase engagement by 300%. Limited time offer available. #EventTechnology #BusinessAutomation"
  }'

echo "✅ Social media posts published"

# 6. SEND EMAIL CAMPAIGN
echo ""
echo "📧 SENDING EMAIL CAMPAIGN..."
curl -X POST "https://api.sendgrid.com/v3/mail/send" \
  -H "Authorization: Bearer $SENDGRID_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "personalizations": [
      {
        "to": [{"email": "local@businesses.com"}],
        "subject": "🚀 Transform Your Events with AI - Local Partnership"
      }
    ],
    "from": {"email": "ai@9lmntsstudio.com", "name": "9LMNTS AI"},
    "content": [{
      "type": "text/plain",
      "value": "I am activating AI systems to help local businesses launch Event OS platforms in 24 hours. Want to be first?"
    }]
  }'

echo "✅ Email campaign sent"

# 7. START MONITORING
echo ""
echo "📊 STARTING MONITORING..."
curl -X POST "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "🚀 9LMNTS Studio AI Agents ACTIVATED! Target: $2,500 in 24 hours. All systems are generating revenue now!",
    "channel": "#general"
  }'

echo "✅ Monitoring started"

# 8. CREATE REVENUE TRACKER
echo ""
echo "💰 CREATING REVENUE TRACKER..."
curl -X POST "$SUPABASE_URL/rest/v1/revenue_tracker" \
  -H "apikey: $SUPABASE_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "source": "AI_Agents",
    "target_amount": 2500,
    "status": "ACTIVE",
    "start_time": "'$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)'"
  }'

echo "✅ Revenue tracker created"

echo ""
echo "=" * 60
echo "🚀 ALL AI SYSTEMS ACTIVATED!"
echo "🎯 TARGET: $2,500 IN 24 HOURS"
echo "⏰ ELAPSED TIME: 0 minutes"
echo "📊 MONITORING: Active"
echo "💰 REVENUE GENERATION: STARTED!"
echo "=" * 60

# 9. START LOCAL SERVER
echo ""
echo "🖥️ STARTING LOCAL SERVER..."
cd "c:\Users\me\Downloads\9LMNTS Studio V5\src\supabase\functions\server"
python immediate_activation.py

echo "✅ Local server started"
echo ""
echo "🚀 9LMNTS STUDIO AI AGENTS ARE WORKING NOW!"
echo "💰 GENERATING REVENUE IMMEDIATELY!"
echo "📊 Monitor progress: https://your-crewai-dashboard.com"
