import React from 'react';

interface FooterProps {
  onNavigate: (page: string) => void;
}

export function Footer({ onNavigate }: FooterProps) {
  return (
    <footer className="bg-[#1A1A1A] border-t border-gray-800 py-8 px-4">
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="text-white font-bold text-lg mb-4">9LMNTS Studio</h3>
            <p className="text-gray-400 text-sm">
              Creating exceptional digital experiences that inspire and engage.
            </p>
          </div>
          
          <div>
            <h4 className="text-white font-semibold mb-4">Services</h4>
            <ul className="space-y-2">
              <li>
                <button 
                  onClick={() => onNavigate('services')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Web Development
                </button>
              </li>
              <li>
                <button 
                  onClick={() => onNavigate('services')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Mobile Apps
                </button>
              </li>
              <li>
                <button 
                  onClick={() => onNavigate('services')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Brand Design
                </button>
              </li>
            </ul>
          </div>
          
          <div>
            <h4 className="text-white font-semibold mb-4">Company</h4>
            <ul className="space-y-2">
              <li>
                <button 
                  onClick={() => onNavigate('about')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  About Us
                </button>
              </li>
              <li>
                <button 
                  onClick={() => onNavigate('portfolio')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Portfolio
                </button>
              </li>
              <li>
                <button 
                  onClick={() => onNavigate('pricing')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Pricing
                </button>
              </li>
            </ul>
          </div>
          
          <div>
            <h4 className="text-white font-semibold mb-4">Connect</h4>
            <ul className="space-y-2">
              <li>
                <button 
                  onClick={() => onNavigate('start-project')}
                  className="text-gray-400 hover:text-white text-sm transition-colors"
                >
                  Start a Project
                </button>
              </li>
              <li>
                <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors">
                  Contact
                </a>
              </li>
            </ul>
          </div>
        </div>
        
        <div className="mt-8 pt-8 border-t border-gray-800 text-center">
          <p className="text-gray-400 text-sm">
            © 2024 9LMNTS Studio. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
}