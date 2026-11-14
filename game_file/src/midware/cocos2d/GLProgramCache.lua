local GLProgramCache = class("GLProgramCache")
local _ENV, _programCache = "GLProgramCache", "GLProgramCache"
function GLProgramCache:addGLProgram(program, key)
	if key and program then
		_programCache[key] = program
	end
end
function GLProgramCache:getGLProgram(key)
	return _programCache[key]
end
function GLProgramCache:destroyInstance()
	_programCache = nil
end
function GLProgramCache:getInstance()
	return self
end
function GLProgramCache:reloadDefaultGLPrograms()
end
function GLProgramCache:loadDefaultGLPrograms()
end
return GLProgramCache
