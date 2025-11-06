# 📡Underground-to-Aboveground Wireless Path Loss Modeling 

**UG_WirelessComm_Modeling** provides MATLAB code for simulating **underground-to-aboveground (UG2AG) wireless signal path loss** in soil. The repository implements multiple path loss models and validates them against experimental measurements.  

---

## ✨ Overview

This repository includes:

1. **Modified Friis Model (MFM)** – Calculates soil absorption and refraction losses using dielectric properties.  
2. **WUSN Path Loss Model (WUSN-PLM)** – Accounts for topsoil and subsoil layers, reflection effects, and burial depth.  
3. **Multi-Layer Signal Propagation Model (MLSPM)** – Proposed model that evaluates signal propagation across multiple soil layers, considering reflection and attenuation in each layer.  

All models compute the total path loss $\(L_{tot}\)$ by combining **air loss, soil absorption, and refraction effects**.

---

## 🛠️ Features

- Implement three UG2AG path loss models: **MFM**, **WUSN-PLM**, **MLSPM**  
- Compute soil dielectric properties for each layer using the **MBSDM method**  
- Compare simulation results with experimental measurements  

---

## ▶️ Usage

Run the main simulation script:  

```matlab
model_measurement_new.m
```


## 📚 References

- [**Modified Friis Model (MFM)**](https://ianakyildiz.com/bwn/papers/2010/j3.pdf)  
- [**WUSN Path Loss Model (WUSN-PLM)**](https://ieeexplore.ieee.org/document/8964471)  
- [**MBSDM Dielectric Model**](https://ieeexplore.ieee.org/document/4895263)  





