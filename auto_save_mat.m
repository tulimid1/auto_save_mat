function auto_save_mat(fileName, varsCell, varsNamesCell, nvArgs)
arguments (Input)
    fileName {mustBeTextScalar}; 
    varsCell (1, :) {mustBeA(varsCell, 'cell')}; 
    varsNamesCell (1, :) {mustBeA(varsNamesCell, 'cell')}; 
    nvArgs.customFolder {mustBeTextScalar} = '';
    nvArgs.folderLevel (1, 1) ...
        {mustBeA(nvArgs.folderLevel, 'double'), mustBeInteger, ...
        mustBeInRange(nvArgs.folderLevel, 1, 3)} = 3; 
end

%% Set up 
currentDir = pwd;
dateDir = date();
for iVar = 1:length(varsCell)
    eval(sprintf('%s = varsCell{%d};', varsNamesCell{iVar}, iVar));
end

%% Navigate 
if isempty(nvArgs.customFolder)
    findOrCreateAndEnterFolder('matFiles');
    findOrCreateAndEnterFolder(dateDir);
else 
    if nvArgs.folderLevel >= 2 
        findOrCreateAndEnterFolder('matFiles');
    end
    if nvArgs.folderLevel == 3 % date folder 
        findOrCreateAndEnterFolder(dateDir); 
    end
    findOrCreateAndEnterFolder(nvArgs.customFolder);
end

try 
    save(fileName, varsNamesCell{:});
catch 
    save(fileName, varsNamesCell{:}, '-v7.3');
end
cd(currentDir);

end

%% Local functions
function findOrCreateAndEnterFolder(folderName)
if ~isfolder(folderName)
    mkdir(folderName)
end
cd(folderName)
end
