-- 9LMNTS Studio - 24-Hour Revenue Blitz Database Schema

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Activation Log Table
CREATE TABLE activation_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  target_amount DECIMAL(10,2) NOT NULL,
  timeframe VARCHAR(50) NOT NULL,
  agents_active TEXT[],
  start_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  status VARCHAR(50) DEFAULT 'ACTIVE',
  end_time TIMESTAMP WITH TIME ZONE,
  total_revenue DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Revenue Tracker Table
CREATE TABLE revenue_tracker (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  source VARCHAR(100) NOT NULL,
  amount DECIMAL(10,2),
  target_amount DECIMAL(10,2),
  status VARCHAR(50) DEFAULT 'PENDING',
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  client_id UUID,
  project_id UUID,
  payment_id VARCHAR(255),
  notes TEXT
);

-- Email Campaigns Table
CREATE TABLE email_campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subject VARCHAR(500) NOT NULL,
  body TEXT NOT NULL,
  target_audience VARCHAR(100),
  status VARCHAR(50) DEFAULT 'DRAFT',
  sent_at TIMESTAMP WITH TIME ZONE,
  opens_count INTEGER DEFAULT 0,
  clicks_count INTEGER DEFAULT 0,
  replies_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Social Posts Table
CREATE TABLE social_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  platform VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  post_url VARCHAR(500),
  status VARCHAR(50) DEFAULT 'DRAFT',
  posted_at TIMESTAMP WITH TIME ZONE,
  likes_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lead Generation Table
CREATE TABLE lead_generation (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  business_name VARCHAR(255) NOT NULL,
  contact_name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(50),
  business_type VARCHAR(100),
  location VARCHAR(255),
  qualification_score INTEGER CHECK (qualification_score >= 1 AND qualification_score <= 10),
  status VARCHAR(50) DEFAULT 'NEW',
  assigned_to VARCHAR(100),
  contacted_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sales Activities Table
CREATE TABLE sales_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lead_id UUID REFERENCES lead_generation(id) ON DELETE CASCADE,
  activity_type VARCHAR(100) NOT NULL, -- 'CALL', 'EMAIL', 'MEETING', 'PROPOSAL'
  description TEXT,
  status VARCHAR(50) DEFAULT 'COMPLETED',
  outcome VARCHAR(100),
  next_action VARCHAR(255),
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agent Performance Table
CREATE TABLE agent_performance (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agent_name VARCHAR(100) NOT NULL,
  task_type VARCHAR(100),
  tasks_completed INTEGER DEFAULT 0,
  success_rate DECIMAL(5,2) DEFAULT 0,
  revenue_generated DECIMAL(10,2) DEFAULT 0,
  time_worked INTEGER DEFAULT 0, -- minutes
  performance_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Quick Actions Table
CREATE TABLE quick_actions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  action_type VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  status VARCHAR(50) DEFAULT 'PENDING',
  priority VARCHAR(20) DEFAULT 'HIGH',
  assigned_agent VARCHAR(100),
  completed_at TIMESTAMP WITH TIME ZONE,
  result TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_revenue_tracker_timestamp ON revenue_tracker(timestamp);
CREATE INDEX idx_email_campaigns_sent_at ON email_campaigns(sent_at);
CREATE INDEX idx_social_posts_posted_at ON social_posts(posted_at);
CREATE INDEX idx_lead_generation_status ON lead_generation(status);
CREATE INDEX idx_sales_activities_timestamp ON sales_activities(timestamp);
CREATE INDEX idx_agent_performance_date ON agent_performance(performance_date);

-- Insert initial activation record
INSERT INTO activation_log (target_amount, timeframe, agents_active, status) 
VALUES (2500, '24 hours', ARRAY['sales', 'lead_gen', 'social', 'email'], 'ACTIVE');

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to tables that need timestamp updates
CREATE TRIGGER update_revenue_tracker_updated_at 
    BEFORE UPDATE ON revenue_tracker
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_email_campaigns_updated_at 
    BEFORE UPDATE ON email_campaigns
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_social_posts_updated_at 
    BEFORE UPDATE ON social_posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lead_generation_updated_at 
    BEFORE UPDATE ON lead_generation
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_activities_updated_at 
    BEFORE UPDATE ON sales_activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agent_performance_updated_at 
    BEFORE UPDATE ON agent_performance
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quick_actions_updated_at 
    BEFORE UPDATE ON quick_actions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
