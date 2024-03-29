# Try to find dpdk v18.08
#
# Once done, this will define
#
# DPDK_FOUND
# DPDK_INCLUDE_DIR
# DPDK_LIBRARIES

find_path(DPDK_INCLUDE_DIR rte_config.h
  PATH_SUFFIXES dpdk
  HINTS $ENV{RTE_SDK}/$ENV{RTE_TARGET}/include)

set(components
    acl bbdev bitratestats bpf bus_dpaa bus_fslmc bus_ifpga bus_pci bus_vdev cfgfile cmdline
     compressdev cryptodev distributor eal efd ethdev eventdev
    flow_classify gro gso hash ip_frag jobstats kni kvargs latencystats
    lpm mbuf member mempool mempool_bucket mempool_dpaa2 mempool_dpaa
    mempool_ring mempool_stack meter metrics net pci pdump pipeline pmd_af_packet
    pmd_ark pmd_avf pmd_avp pmd_axgbe pmd_bbdev_null pmd_bnxt pmd_bond pmd_crypto_scheduler
    pmd_cxgbe pmd_dpaa2 pmd_dpaa2_cmdif pmd_dpaa2_event pmd_dpaa2_qdma pmd_dpaa2_sec
    pmd_dpaa pmd_dpaa_event pmd_dpaa_sec pmd_e1000 pmd_ena pmd_enic pmd_failsafe pmd_fm10k
    pmd_i40e pmd_ifpga_rawdev pmd_ixgbe pmd_kni pmd_lio pmd_nfp pmd_null
    pmd_null_crypto   pmd_opdl_event pmd_qede pmd_ring
    pmd_sfc_efx pmd_skeleton_event pmd_skeleton_rawdev pmd_softnic pmd_sw_event
    pmd_tap pmd_thunderx_nicvf pmd_vdev_netvsc pmd_vhost pmd_virtio pmd_virtio_crypto
    pmd_vmxnet3_uio port power rawdev reorder ring sched security table timer vhost)

foreach(c ${components})
  find_library(DPDK_rte_${c}_LIBRARY rte_${c}
    HINTS $ENV{RTE_SDK}/$ENV{RTE_TARGET}/lib)
endforeach()

foreach(c ${components})
  list(APPEND check_LIBRARIES "${DPDK_rte_${c}_LIBRARY}")
endforeach()

mark_as_advanced(DPDK_INCLUDE_DIR ${check_LIBRARIES})

if (EXISTS ${WITH_DPDK_MLX5})
  find_library(DPDK_rte_pmd_mlx5_LIBRARY rte_pmd_mlx5)
  list(APPEND check_LIBRARIES ${DPDK_rte_pmd_mlx5_LIBRARY})
  mark_as_advanced(DPDK_rte_pmd_mlx5_LIBRARY)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(dpdk DEFAULT_MSG
  DPDK_INCLUDE_DIR
  check_LIBRARIES)

if(DPDK_FOUND)
  if(EXISTS ${WITH_DPDK_MLX5})
    list(APPEND check_LIBRARIES -libverbs)
  endif()
  set(DPDK_LIBRARIES
    -Wl,--whole-archive ${check_LIBRARIES} -lpthread -lnuma -ldl -Wl,--no-whole-archive)
endif(DPDK_FOUND)