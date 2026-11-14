local worldMapViewObject = class("worldMapViewObject", function(target, param)
	return target
end)
function worldMapViewObject:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods(true)
end
function worldMapViewObject:addComponents(config)
	_UPVALUE13_ = nil
	;(nil)[1] = "worldMapComUI"
	;(nil)[2] = "worldMapComViewPiece"
	;(nil)[3] = "worldMapComInstanceNormal"
	;(nil)[4] = "worldMapComMoveline"
	;(nil)[5] = "worldMapComButton"
	;(nil)[6] = "worldMapComUtil"
	;(nil)[7] = "worldMapComTransfer"
	;(nil)[8] = "worldMapComForbidWar"
	;(nil)[9] = "worldMapComGuide"
	;(nil)[10] = "worldMapComSelect"
	;(nil)[11] = "worldMapComGroup"
	;(nil)[12] = "worldMapCom3D"
	local (nil)[13], comTable = "worldMapComTileEffect", nil
	for _, v in ipairs(comTable) do
		self:addCustomComponent(v, nil, config)
	end
	if config.noScaleLimit then
		if config.lodCfg then
			for _, v in ipairs(config.lodCfg) do
				self:addCustomComponent(v.component, v.name, v.param)
			end
		end
		if config.comTableLod then
			for _, v in ipairs(config.comTableLod) do
				self:addCustomComponent(v, nil, config)
			end
		end
	end
	local other = config and config.comTable
	if other then
		for _, v in ipairs(other) do
			self:addCustomComponent(v, nil, config)
		end
	end
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidAllianceMark() or worldMapWarDef.isInWarForbidCampMark() then
		self:addCustomComponent("worldMapComAllianceMark")
	end
	if config.noScaleLimit then
		self:addCustomComponent("worldMapComLod", nil, config)
		self:addCustomComponent("worldMapComLodUI")
	else
		self:addCustomComponent("worldMapComLodDumy")
	end
end
function worldMapViewObject:addCustomComponent(component, name, ...)
	return self:addComponent(getfullname(component), name or component, ...):exportMethods()
end
function worldMapViewObject:callComFunc(name)
	for _, v in ipairs(self.componentsArray_) do
		local fun = v[name]
		if fun then
			fun(v)
		end
	end
end
function worldMapViewObject:callComFuncArgs(name, ...)
	for _, v in ipairs(self.componentsArray_) do
		local fun = v[name]
		if fun then
			fun(v, ...)
		end
	end
end
return worldMapViewObject
