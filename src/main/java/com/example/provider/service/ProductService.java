package com.example.provider.service;

import org.springframework.stereotype.Service;

import com.example.provider.model.Product;

@Service
public class ProductService {

	public Product getProduct(Integer id) {
		if (id == 999) {
			throw new RuntimeException("Product not found");
		}

		if (id == 2) {
			throw new RuntimeException("Internal Server Error");
		}

		return new Product(1, "Laptop", 45000.0);
	}

}
