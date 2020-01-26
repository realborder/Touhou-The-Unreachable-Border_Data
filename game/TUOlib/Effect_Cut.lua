local m={}
tuolib.effect_cut=m
m.enable_boss_effect=true
m.enable_shader=true
m.enable_background=true
m.oldfunc1=PostEffectCapture
PostEffectCapture=function(...)
    if m.enable_shader then
        m.oldfunc1(...)
    end
end
m.oldfunc2=PostEffectApply
PostEffectApply=function(...)
    if m.enable_shader then
        m.oldfunc2(...)
    end
end
m.oldfunc3=PushRenderTarget
PushRenderTarget=function(...)
    if m.enable_shader then
        m.oldfunc3(...)
    end
end
m.oldfunc4=PopRenderTarget
PopRenderTarget=function(...)
    if m.enable_shader then
        m.oldfunc4(...)
    end
end
m.oldfunc5=PostEffect
---@param rendertarget string
---@param fx string
---@param parameter table
PostEffect=function(...)
    if m.enable_shader then
        m.oldfunc5(...)
    end
end
-- m.old_bg_render=background.render
-- function background:render()
--     m.old_bg_render()    
--     if not m.enable_background then return end
-- end