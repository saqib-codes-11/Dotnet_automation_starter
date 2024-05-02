#!/bin/bash

# Input prompts and variable assignments
read -p "Project name (readable version): " ProjectName
read -p "Brief resume of this project: " ProjectDescription
read -p "Solution name / NuGet package name (SlugVersion): " SolutionName
read -p "GitHub username: " GitHubUsername
read -p "GitHub repository: " GitHubRepo
read -p "AppVeyor project ID: " AppVeyorId
read -p "Codacy project ID: " CodacyId
read -p "Code Climate project ID: " CodeClimateId
read -p "Company/Author name (package copyright): " CompanyName
read -p "Codacy secure token (AppVeyor): " CodacyToken
read -p "Code Climate secure token (AppVeyor): " CodeClimateToken
read -p "Sonar Cloud secure token (AppVeyor): " SonarCloudToken
read -p "API documentation URL: " DocumentationWebsite

# File path variables
MainProjectFile="Src/$SolutionName/$SolutionName.csproj"
IntegrationTestProjectFile="Tests/$SolutionName.IntegrationTests/$SolutionName.IntegrationTests.csproj"
UnitTestProjectFile="Tests/$SolutionName.UnitTests/$SolutionName.UnitTests.csproj"

# Remove lines from README.md
sed -i '25,$d' README.md

# Perform text replacements in README.md
sed -i "s/{username}/$GitHubUsername/g" README.md
sed -i "s/{repo}/$GitHubRepo/g" README.md
sed -i "s/{appVeyorId}/$AppVeyorId/g" README.md
sed -i "s/{codacyId}/$CodacyId/g" README.md
sed -i "s/{codeClimateId}/$CodeClimateId/g" README.md
sed -i "s/SolutionName/$SolutionName/g" README.md
sed -i "s/{PackageName}/$SolutionName/g" README.md
sed -i "s/{Project Name}/$ProjectName/g" README.md
sed -i "s/{Project Description}/$ProjectDescription/g" README.md
sed -i "s|https://project.name.com/|$DocumentationWebsite|g" README.md

# Perform text replacements in .wakatime-project
sed -i "s/API Client Boilerplate .NET/$ProjectName SDK .NET/g" .wakatime-project

# Perform text replacements in _config.yml
sed -i "s/API Client Boilerplate/$ProjectName/g" _config.yml
sed -i "s/A template repository for .NET API clients projects./$ProjectDescription/g" _config.yml
sed -i "s|GuilhermeStracini/apiclient-boilerplate-dotnet|$GitHubUsername/$GitHubRepo|g" _config.yml

# Perform text replacements in appveyor.yml
sed -i "s/<secure token from Codacy>/$CodacyToken/g" appveyor.yml
sed -i "s/<secure token from CodeClimate>/$CodeClimateToken/g" appveyor.yml
sed -i "s/<secure token from Sonar Cloud>/$SonarCloudToken/g" appveyor.yml

# Perform text replacements in .cs and .csproj files recursively
find . -type f -name '*.cs' -exec sed -i "s/SolutionName/$SolutionName/g" {} \;
find . -type f -name '*.csproj' -exec sed -i "s/SolutionName/$SolutionName/g" {} \;

# Rename SolutionName.sln
sed -i "s/SolutionName/$SolutionName/g" SolutionName.sln
mv SolutionName.sln "$SolutionName.sln"

# Perform text replacements in the main project file
sed -i "s/{username}/$GitHubUsername/g" "$MainProjectFile"
sed -i "s/{repo}/$GitHubRepo/g" "$MainProjectFile"
sed -i "s/{companyName}/$CompanyName/g" "$MainProjectFile"
sed -i "s/{project description}/$ProjectDescription/g" "$MainProjectFile"

# Rename project files and directories
mv "$MainProjectFile" "$SolutionName.csproj"
mv "$IntegrationTestProjectFile" "$SolutionName.IntegrationTests.csproj"
mv "$UnitTestProjectFile" "$SolutionName.UnitTests.csproj"
mv "Src/SolutionName" "Src/$SolutionName"
mv "Tests/SolutionName.IntegrationTests" "Tests/$SolutionName.IntegrationTests"
mv "Tests/SolutionName.UnitTests" "Tests/$SolutionName.UnitTests"

# Remove initial setup files
rm initial-setup.bat
rm initial-setup.ps1
