local _ENV, _ENV, _ENV, eliteSoldiersDef
;(nil).json = "spine/soldiersV4/jingling01.skel"
;(nil).atlas = "spine/soldiersV4/jingling01.atlas"
;(nil).scale = 1
_ENV, (nil)[6], (nil).pos = nil, nil, cc.p(0, 0)
;(nil).json = "spine/soldiersV4/jingling02.skel"
;(nil).atlas = "spine/soldiersV4/jingling02.atlas"
;(nil).scale = 1
_ENV, (nil)[7], (nil).pos = nil, nil, cc.p(0, 25)
;(nil).json = "spine/soldiersV4/jingling03.skel"
;(nil).atlas = "spine/soldiersV4/jingling03.atlas"
;(nil).scale = 1
_ENV, (nil)[8], (nil).pos = nil, nil, cc.p(40, 60)
;(nil).json = "spine/soldiersV4/jingling04.skel"
;(nil).atlas = "spine/soldiersV4/jingling04.atlas"
;(nil).scale = 1
_ENV, (nil)[9], (nil).pos = nil, nil, cc.p(0, 20)
;(nil).json = "spine/soldiersV4/jingling05.skel"
;(nil).atlas = "spine/soldiersV4/jingling05.atlas"
;(nil).scale = 1
eliteSoldiersDef.config, (nil)[10], (nil).pos = nil, nil, cc.p(0, 20)
_ENV, eliteSoldiersDef.getSpineByLv = function(lv)
	return eliteSoldiersDef.getSpineByModelType(worldMapDefine.soldierType_JingYing, lv)
end, function(lv)
	return eliteSoldiersDef.getSpineByModelType(worldMapDefine.soldierType_JingYing, lv)
end
eliteSoldiersDef.modelTypeConfig, (function(lv)
	return eliteSoldiersDef.getSpineByModelType(worldMapDefine.soldierType_JingYing, lv)
end)[worldMapDefine.soldierType_JingYing] = function(lv)
	return eliteSoldiersDef.getSpineByModelType(worldMapDefine.soldierType_JingYing, lv)
end, eliteSoldiersDef.config
function eliteSoldiersDef.getSpineByModelType(modelType, lv)
	local spine
	local scale = 1
	local mdata = eliteSoldiersDef.modelTypeConfig[modelType]
	local data = mdata and mdata[lv]
	if data then
		spine = sp.SkeletonAnimation:create(data.json, data.atlas, 1)
		spine:setPosition(data.pos)
		scale = data.scale
	end
	return spine, scale
end
function eliteSoldiersDef.getSpineCfg(modelType, lv)
	local spine
	if not eliteSoldiersDef.modelTypeConfig[modelType] then
		local eliteSoldiersDef, mdata = eliteSoldiersDef.modelTypeConfig[modelType], eliteSoldiersDef.modelTypeConfig[modelType]
	end
	return mdata[lv]
end
return eliteSoldiersDef
