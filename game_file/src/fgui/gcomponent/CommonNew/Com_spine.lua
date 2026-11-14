local baseComponent = require("fgui.base.baseComponent")
local Com_spine = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_spine", Com_spine)
fgui.register_extension("ui://LoginView/Com_spine", Com_spine)
local prefabDef = include("prefabDef")
local isUnityNull = function(obj)
	if obj == nil then
		return true
	end
	if tolua and tolua.isnull then
		return tolua.isnull(obj)
	end
	return false
end
function Com_spine:onInit()
	self._loadedEffect = false
	self.bonePrefabMap, _UPVALUE0_, self.animationName = nil, nil, "animation"
	self.loop = true
	self.spineScale = 1
	self.isAsync = false
end
function Com_spine:onShow()
	self.effectPath = self:getCustomData()
	print("spine path:=====", self.effectPath)
	self:updateEffect()
end
function Com_spine:setVisible(value)
	fgui.GObject.setVisible(self, value)
	self:updateEffect()
end
function Com_spine:setEffectPath(path, animationName, loop)
	if self.effectPath == path then
		return
	end
	self._loadedEffect = false
	self.effectPath = path
	self.animationName = animationName and animationName or "animation"
	self.loop = loop == nil and self.loop or loop
	self:updateEffect()
end
function Com_spine:clearEffect()
	self._loadedEffect = false
	self.fields.Loader3D:clearContent()
	self.bonePrefabMap, _UPVALUE0_ = self.fields.Loader3D.clearContent, self.fields.Loader3D.clearContent
end
function Com_spine:updateEffect()
	if self._loadedEffect then
		return
	end
	if not self:isVisible() then
		return
	end
	self._loadedEffect = true
	self.fields.Loader3D:clearContent()
	self.bonePrefabMap, _ENV = self.fields.Loader3D.clearContent, self.fields.Loader3D.clearContent
	self.effect = nil
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty")
		return
	end
	print("create effectPath", self.effectPath)
	local atlasPath = string.gsub(self.effectPath, "%.%w+$", ".atlas")
	local spine = sp.SkeletonAnimation:create(self.effectPath, atlasPath, self.spineScale, nil, self.isAsync)
	if isUnityNull(spine) then
		self._loadedEffect = false
		print("create spine failed:", self.effectPath)
		return
	end
	if self.spineColor then
		spine:setColor(self.spineColor)
	end
	if self.spinePos then
		spine:setPosition(self.spinePos)
	end
	self.effect = spine
	spine:setAnimation(0, self.animationName, self.loop)
	self.fields.Loader3D:setContent(self.effect)
end
function Com_spine:setLoop(value)
	self.loop = value
	if not isUnityNull(self.effect) then
		self.effect:setLoop(value)
	end
end
function Com_spine:updateSpineColor(color)
	self.spineColor = color
	if not isUnityNull(self.effect) then
		self.effect:setColor(color)
	end
end
function Com_spine:setSpinePos(pos)
	self.spinePos = pos
	if not isUnityNull(self.effect) then
		self.effect:setPosition(pos)
	end
end
function Com_spine:setSpineScale(scale)
	self.spineScale = scale or 1
end
function Com_spine:setIsAsync(isAsync)
	self.isAsync = isAsync
end
function Com_spine:getSpine()
	return self.effect
end
function Com_spine:pause()
	if not isUnityNull(self.effect) then
		self:stopAllActions()
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function()
			if not isUnityNull(self.effect) then
				self.effect:setAnimation(0, "animation", false)
			end
		end)
		;(nil)[2] = ffa.delay(0.016666666666666666)
		;(nil)[3] = ffa.callFunc(function()
			if not isUnityNull(self.effect) then
				self.effect:clearTracks()
			end
		end)
		;(nil)[4] = ffa.callFunc(function()
			if not isUnityNull(self.effect) then
				self.effect:clearTracks()
			end
		end)
		self:runAction(ffa.seq(nil))
	end
end
function Com_spine:start(animationName, loop)
	if not isUnityNull(self.effect) then
		self.effect:setAnimation(0, animationName or "animation", loop == nil or loop)
	end
end
function Com_spine:addPrefab(boneName, prefabCfg)
	if isUnityNull(self.effect) then
		return
	end
	if type(boneName) ~= "string" or string.len(boneName) == 0 then
		return
	end
	local list = prefabCfg
	if type(list) == "string" then
		_ENV = type(list)
		list, type(list)[1] = type(list), list
	elseif type(list) == "table" and list.prefab then
		_ENV = list.prefab
		list, list.prefab[1] = list.prefab, list
	end
	if type(list) ~= "table" then
		return
	end
	if not self.bonePrefabMap[boneName] then
		self.bonePrefabMap[boneName], isUnityNull = list, list
	end
	dump(list, "list===")
	for _, v in ipairs(list) do
		local prefabName
		if type(v) == "string" then
			prefabName = v
		elseif type(v) == "table" then
			prefabName = v.prefab or v[1]
		end
		if type(prefabName) == "string" and string.len(prefabName) > 0 then
			local path = prefabDef.getPrefabPath(prefabName)
			if not SoraDisInList(path, self.bonePrefabMap[boneName]) and not isUnityNull(self.effect) then
				do
					local ok, err = pcall(function()
						self.effect:attachEffectToBone(boneName, path)
					end)
					if ok then
						table.insert(self.bonePrefabMap[boneName], path)
					else
						print("Com_spine:addPrefab failed:", boneName, path, err)
					end
				end
			end
		end
	end
end
function Com_spine:getBonePos(boneName)
	if not isUnityNull(self.effect) then
		return self.effect:getBonePosition(boneName)
	end
end
function Com_spine:setBoneRotation(boneName, angle)
	if not isUnityNull(self.effect) then
		return self.effect:setBoneRotation(boneName, angle)
	end
end
function Com_spine:getBoneRotation(boneName)
	if not isUnityNull(self.effect) then
		return self.effect:getBoneRotation(boneName)
	end
end
function Com_spine:clearBoneRotation(boneName)
	if not isUnityNull(self.effect) then
		return self.effect:clearBoneRotation(boneName)
	end
end
function Com_spine:setPlaybackSpeed(speed)
	if not isUnityNull(self.effect) then
		self.effect:setPlaybackSpeed(speed)
	end
end
return Com_spine
