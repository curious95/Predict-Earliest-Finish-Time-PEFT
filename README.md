# Predict-Earliest-Finish-Time-PEFT
Predict Earliest Finish Time Matlab Implementation

PEFT algorithm outperforms the state-of list-based algorithms for heterogeneous systems. The algorithm has two major phases: a task prioritizing phase for computing task priorities, and a processor selection phase for selecting the best processor for executing the current task. For task prioritizing it computes the OCT table. where each element   indicates the maximum of the shortest paths of children’s tasks to the exit node considering that processor   is selected for task The OCT value of task ti on processor is recursively defined by traversing the DAG from the exit task to the entry task.

To define task priority, we compute the average OCT for each task that. To select a processor for a task, we compute the Optimistic  which sums to EFT the computation time of the longest path to the exit node. in the processor selection; perhaps it does not select the processor that achieves the Earliest Finish Time for the current task, but it selects the shorter finish time for the tasks in the next steps. The aim is guarantee that the tasks ahead will finish earlier, which is the purpose of the OCT table. OEFT is defined as
                          
