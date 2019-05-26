ph3_compiler={}

ph3_compiler.taskwraper=function(taskname,arguments)
	"function "..taskname..arguments.." return task.New(_taskbase,function _)"
end