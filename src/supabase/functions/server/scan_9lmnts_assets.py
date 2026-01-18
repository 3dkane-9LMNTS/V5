#!/usr/bin/env python3
"""
🔍 9LMNTS STUDIO ASSETS SCANNER
Auto-scan all project folders and generate Notion-ready CSV
"""

import os
import json
import csv
from pathlib import Path
from datetime import datetime

def scan_directory(root_dir, project_name, ignore_dirs=None):
    """Scan directory recursively and return file list"""
    if ignore_dirs is None:
        ignore_dirs = {
            'node_modules', '.git', 'dist', 'build', '.next', '.nuxt', 
            'coverage', '.vscode', '.idea', '__pycache__', '.pytest_cache',
            'venv', 'env', '.env'
        }
    
    files = []
    root_path = Path(root_dir)
    
    if not root_path.exists():
        print(f"❌ Path does not exist: {root_dir}")
        return files
    
    try:
        for item in root_path.rglob('*'):
            if item.is_file():
                # Skip ignored directories
                if any(ignore_dir in str(item) for ignore_dir in ignore_dirs):
                    continue
                
                stat = item.stat()
                files.append({
                    'path': str(item.absolute()),
                    'name': item.name,
                    'size': stat.st_size,
                    'mtime': datetime.fromtimestamp(stat.st_mtime).isoformat(),
                    'ext': item.suffix.lower(),
                    'dir': str(item.parent.absolute()),
                    'relative_path': str(item.relative_to(root_path)),
                    'project': project_name
                })
    except Exception as e:
        print(f"❌ Error scanning {root_dir}: {str(e)}")
    
    return files

def main():
    """Main scanning function"""
    print("🔍 SCANNING 9LMNTS STUDIO PROJECTS...")
    print("=" * 60)
    
    # CONFIGURE YOUR PROJECT ROOTS HERE
    project_roots = [
        ("c:/Users/me/Downloads/9LMNTS Studio V3", "9LMNTS Studio V3"),
        ("c:/Users/me/Downloads/9LMNTS Studio V4", "9LMNTS Studio V4"),
        ("c:/Users/me/Downloads/9LMNTS Studio V5", "9LMNTS Studio V5")
    ]
    
    all_files = []
    
    # Scan each project
    for i, (root_dir, project_name) in enumerate(project_roots):
        print(f"\n📁 Scanning Project {i+1}: {project_name}")
        print(f"   Path: {root_dir}")
        
        files = scan_directory(root_dir, project_name)
        print(f"✅ Found {len(files)} files")
        all_files.extend(files)
    
    # Group files by various criteria
    by_extension = {}
    by_project = {}
    by_directory = {}
    
    for file in all_files:
        # Group by extension
        ext = file['ext']
        if ext not in by_extension:
            by_extension[ext] = []
        by_extension[ext].append(file)
        
        # Group by project
        project = file['project']
        if project not in by_project:
            by_project[project] = []
        by_project[project].append(file)
        
        # Group by directory
        dir_path = file['dir']
        if dir_path not in by_directory:
            by_directory[dir_path] = []
        by_directory[dir_path].append(file)
    
    # Create comprehensive scan results
    scan_results = {
        'scan_info': {
            'timestamp': datetime.now().isoformat(),
            'total_files': len(all_files),
            'projects_scanned': len(project_roots),
            'projects': [{'path': path, 'name': name} for path, name in project_roots]
        },
        'summary': {
            'by_extension': [
                {
                    'extension': ext,
                    'count': len(files),
                    'total_size': sum(f['size'] for f in files),
                    'examples': [f['relative_path'] for f in files[:3]]
                }
                for ext, files in by_extension.items()
            ],
            'by_project': [
                {
                    'project': project,
                    'count': len(files),
                    'total_size': sum(f['size'] for f in files),
                    'file_types': list(set(f['ext'] for f in files))
                }
                for project, files in by_project.items()
            ]
        },
        'files': all_files
    }
    
    # Write comprehensive scan results
    with open('9lmnts_assets_scan.json', 'w', encoding='utf-8') as f:
        json.dump(scan_results, f, indent=2, ensure_ascii=False)
    
    # Create Notion-ready CSV
    csv_headers = [
        'Name', 'Path', 'Relative Path', 'Project', 'Extension', 
        'Size (bytes)', 'Size (KB)', 'Modified', 'Directory', 
        'Asset Type', 'Category', 'Status', 'Notes'
    ]
    
    with open('9lmnts_assets_for_notion.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(csv_headers)
        
        for file in all_files:
            row = [
                file['name'],
                file['path'],
                file['relative_path'],
                file['project'],
                file['ext'],
                file['size'],
                round(file['size'] / 1024, 2),
                file['mtime'],
                file['dir'],
                '',  # Asset Type - to be filled manually
                '',  # Category - to be filled manually
                '',  # Status - to be filled manually
                ''   # Notes - to be filled manually
            ]
            writer.writerow(row)
    
    # Display summary
    print("\n" + "=" * 60)
    print("📊 SCAN SUMMARY")
    print("=" * 60)
    print(f"📁 Total Files: {scan_results['scan_info']['total_files']}")
    print(f"📁 Projects Scanned: {scan_results['scan_info']['projects_scanned']}")
    print(f"📁 Output Files: 9lmnts_assets_scan.json, 9lmnts_assets_for_notion.csv")
    
    print("\n📋 BY PROJECT:")
    for project_info in scan_results['summary']['by_project']:
        size_mb = project_info['total_size'] / 1024 / 1024
        print(f"  📁 {project_info['project']}: {project_info['count']} files, {size_mb:.2f}MB")
    
    print("\n📋 TOP FILE TYPES:")
    sorted_extensions = sorted(scan_results['summary']['by_extension'], 
                            key=lambda x: x['count'], reverse=True)
    for ext_info in sorted_extensions[:10]:
        print(f"  📄 {ext_info['extension']}: {ext_info['count']} files")
    
    print("\n🎯 NEXT STEPS:")
    print("1. 📊 Review 9lmnts_assets_scan.json for detailed analysis")
    print("2. 📋 Import 9lmnts_assets_for_notion.csv into Notion Assets")
    print("3. 🏷️  Fill in Asset Type, Category, Status columns")
    print("4. 📊 Use the data for revenue generation strategy")
    print("5. 🚀 Identify ready-to-sell products immediately")
    
    print("\n✅ Scan complete! Files saved to current directory.")
    
    # Show interesting patterns
    print("\n🔍 INTERESTING PATTERNS:")
    
    # Look for revenue-generating assets
    revenue_files = []
    for file in all_files:
        name_lower = file['name'].lower()
        if any(keyword in name_lower for keyword in [
            'license', 'pricing', 'payment', 'checkout', 'buy', 'purchase',
            'demo', 'portfolio', 'service', 'product', 'offer', 'sale'
        ]):
            revenue_files.append(file)
    
    if revenue_files:
        print(f"💰 Found {len(revenue_files)} potential revenue-generating files:")
        for file in revenue_files[:5]:
            print(f"   📄 {file['relative_path']} ({file['project']})")
    
    # Look for Event OS templates
    event_os_files = []
    for file in all_files:
        if 'event' in file['relative_path'].lower() or 'os' in file['relative_path'].lower():
            event_os_files.append(file)
    
    if event_os_files:
        print(f"\n🎪 Found {len(event_os_files)} Event OS related files:")
        for file in event_os_files[:5]:
            print(f"   📄 {file['relative_path']} ({file['project']})")

if __name__ == "__main__":
    main()
