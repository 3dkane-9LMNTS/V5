import fs from 'fs';
import path from 'path';

function walk(dir, list = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (["node_modules", ".git", "dist", "build", ".next", ".nuxt", "coverage", ".vscode", ".idea"].includes(entry.name)) continue;
      walk(full, list);
    } else {
      const stat = fs.statSync(full);
      list.push({
        path: full,
        name: entry.name,
        size: stat.size,
        mtime: stat.mtime.toISOString(),
        ext: path.extname(entry.name).toLowerCase(),
        dir: path.dirname(full),
        relativePath: path.relative(process.cwd(), full)
      });
    }
  }
  return list;
}

// CONFIGURE YOUR PROJECT ROOTS HERE
const projectRoots = [
  "c:/Users/me/Downloads/9LMNTS Studio V3",
  "c:/Users/me/Downloads/9LMNTS Studio V4", 
  "c:/Users/me/Downloads/9LMNTS Studio V5"
];

console.log("🔍 SCANNING 9LMNTS STUDIO PROJECTS...");
console.log("=" * 60);

const allFiles = [];

projectRoots.forEach((root, index) => {
  console.log(`\n📁 Scanning Project ${index + 1}: ${root}`);
  
  if (!fs.existsSync(root)) {
    console.log(`❌ Path does not exist: ${root}`);
    return;
  }
  
  try {
    const files = walk(root);
    console.log(`✅ Found ${files.length} files in ${path.basename(root)}`);
    allFiles.push(...files.map(f => ({...f, project: path.basename(root)})));
  } catch (error) {
    console.log(`❌ Error scanning ${root}: ${error.message}`);
  }
});

// Group by file type for easy analysis
const byExtension = {};
const byProject = {};
const byDirectory = {};

allFiles.forEach(file => {
  // Group by extension
  if (!byExtension[file.ext]) byExtension[file.ext] = [];
  byExtension[file.ext].push(file);
  
  // Group by project
  if (!byProject[file.project]) byProject[file.project] = [];
  byProject[file.project].push(file);
  
  // Group by directory
  if (!byDirectory[file.dir]) byDirectory[file.dir] = [];
  byDirectory[file.dir].push(file);
});

// Create comprehensive scan results
const scanResults = {
  scanInfo: {
    timestamp: new Date().toISOString(),
    totalFiles: allFiles.length,
    projectsScanned: projectRoots.length,
    projects: projectRoots.map(p => ({path: p, name: path.basename(p)}))
  },
  summary: {
    byExtension: Object.entries(byExtension).map(([ext, files]) => ({
      extension: ext,
      count: files.length,
      totalSize: files.reduce((sum, f) => sum + f.size, 0),
      examples: files.slice(0, 3).map(f => f.relativePath)
    })),
    byProject: Object.entries(byProject).map(([project, files]) => ({
      project,
      count: files.length,
      totalSize: files.reduce((sum, f) => sum + f.size, 0),
      fileTypes: [...new Set(files.map(f => f.ext))]
    }))
  },
  files: allFiles
};

// Write comprehensive scan results
fs.writeFileSync("9lmnts_assets_scan.json", JSON.stringify(scanResults, null, 2));

// Create Notion-ready CSV
const csvHeaders = [
  'Name', 'Path', 'Relative Path', 'Project', 'Extension', 
  'Size (bytes)', 'Size (KB)', 'Modified', 'Directory', 
  'Asset Type', 'Category', 'Status', 'Notes'
];

const csvRows = [csvHeaders.join(',')];

allFiles.forEach(file => {
  const row = [
    `"${file.name}"`,
    `"${file.path}"`,
    `"${file.relativePath}"`,
    `"${file.project}"`,
    `"${file.ext}"`,
    file.size,
    (file.size / 1024).toFixed(2),
    `"${file.mtime}"`,
    `"${file.dir}"`,
    '', // Asset Type - to be filled manually
    '', // Category - to be filled manually
    '', // Status - to be filled manually
    ''  // Notes - to be filled manually
  ];
  csvRows.push(row.join(','));
});

fs.writeFileSync("9lmnts_assets_for_notion.csv", csvRows.join('\n'));

// Create summary report
console.log("\n" + "=" * 60);
console.log("📊 SCAN SUMMARY");
console.log("=" * 60);
console.log(`📁 Total Files: ${scanResults.scanInfo.totalFiles}`);
console.log(`📁 Projects Scanned: ${scanResults.scanInfo.projectsScanned}`);
console.log(`📁 Output Files: 9lmnts_assets_scan.json, 9lmnts_assets_for_notion.csv`);

console.log("\n📋 BY PROJECT:");
scanResults.summary.byProject.forEach(p => {
  console.log(`  📁 ${p.project}: ${p.count} files, ${(p.totalSize / 1024 / 1024).toFixed(2)}MB`);
});

console.log("\n📋 TOP FILE TYPES:");
scanResults.summary.byExtension
  .sort((a, b) => b.count - a.count)
  .slice(0, 10)
  .forEach(ext => {
    console.log(`  📄 ${ext.extension}: ${ext.count} files`);
  });

console.log("\n🎯 NEXT STEPS:");
console.log("1. 📊 Review 9lmnts_assets_scan.json for detailed analysis");
console.log("2. 📋 Import 9lmnts_assets_for_notion.csv into Notion Assets");
console.log("3. 🏷️  Fill in Asset Type, Category, Status columns");
console.log("4. 📊 Use the data for revenue generation strategy");
console.log("\n✅ Scan complete! Files saved to current directory.");
